//
//  Camera.swift
//  AVFoundationPractice
//
//  Created by 임영택 on 2/22/25.
//

import Foundation
import AVFoundation
import CoreImage
import OSLog
import UIKit

class Camera: NSObject {
    private let captureSession = AVCaptureSession()
    private var isCaptureSessionConfigured = false
    private var deviceInput: AVCaptureDeviceInput?
    private var videoOutput: AVCaptureVideoDataOutput?
    private var movieFileOutput: AVCaptureMovieFileOutput?
    private var sessionQueue = DispatchQueue(label: "com.youngtaek.iOSStudy.Camera.sessionQueue")
    
    private var allCaptureDevices: [AVCaptureDevice] {
        AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInTrueDepthCamera, .builtInDualCamera, .builtInDualWideCamera, .builtInWideAngleCamera, .builtInDualWideCamera],
            mediaType: .video,
            position: .unspecified
        )
        .devices
    }
    
    private var frontCaptureDevices: [AVCaptureDevice] {
        allCaptureDevices.filter { $0.position == .front }
    }
    
    private var backCaptureDevices: [AVCaptureDevice] {
        allCaptureDevices.filter { $0.position == .back }
    }
    
    private var captureDevices: [AVCaptureDevice] {
        var devices: [AVCaptureDevice] = []
        #if os(macOS) || os(iOS) && targetEnvironment(macCatalyst) // on Mac
        devices += allCaptureDevices
        #else // on physical iPhone or iPad
        if let backPrimaryDevice = backCaptureDevices.first {
            devices += [backPrimaryDevice]
        }
        if let frontPrimaryDevice = frontCaptureDevices.first {
            devices += [frontPrimaryDevice]
        }
        #endif
        return devices
    }
    
    private var availableCaptureDevices: [AVCaptureDevice] {
        captureDevices
            .filter { $0.isConnected }
            .filter { !$0.isSuspended }
    }
    
    private var captureDevice: AVCaptureDevice? {
        didSet {
            guard let captureDevice = captureDevice else { return }
            logger.debug("[captureDevice didSet] \(captureDevice.localizedName)")
            sessionQueue.async {
                self.updateSessionForCaptureDevice(captureDevice)
            }
        }
    }
    
    var isRunning: Bool {
        captureSession.isRunning
    }
    
    var isRecording: Bool {
        movieFileOutput?.isRecording ?? false
    }
    
    private var addToPreviewStream: ((CIImage) -> Void)?
    
    lazy var previewStream: AsyncStream<CIImage> = {
        AsyncStream { continuation in
            addToPreviewStream = { ciImage in
                continuation.yield(ciImage)
            }
        }
    }()
    
    private var deviceOrientation: UIDeviceOrientation {
        var orientation = UIDevice.current.orientation
        if orientation == .unknown {
            logger.warning("Device's orientation is unknown. Will set to portrait.")
            orientation = .portrait
        }
        return orientation
    }
    
    override init() {
        super.init()
        captureDevice = availableCaptureDevices.first ?? AVCaptureDevice.default(for: .video)
    }
    
    private func configureCaptureSession(completionHandler: (_ success: Bool) -> Void) {
        var success = false
        
        self.captureSession.beginConfiguration()
        
        defer {
            self.captureSession.commitConfiguration()
            completionHandler(success)
        }
        
        // MARK: add input and outputs
        
        guard let captureDevice = captureDevice,
              let deviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            logger.error("failed to obtain video input")
            return
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "com.youngtaek.iOSStudy.Camera.videoOutputQueue"))
        
        guard captureSession.canAddOutput(videoOutput) else {
            logger.error("Unable to add video output to capture session")
            return
        }
        
        let movieOutput = AVCaptureMovieFileOutput()
        
        guard captureSession.canAddOutput(movieOutput) else {
            logger.error("Unable to add movie file output to capture session.")
            return
        }
        
        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)
        captureSession.addOutput(movieOutput)
        
        self.deviceInput = deviceInput
        self.videoOutput = videoOutput
        self.movieFileOutput = movieOutput
        
        isCaptureSessionConfigured = true
        success = true
    }
    
    private func checkAuthorization() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            logger.debug("Camera access authorized.")
            return true
        case .notDetermined:
            logger.debug("Camera access not determined.")
            sessionQueue.suspend()
            let status = await AVCaptureDevice.requestAccess(for: .video)
            sessionQueue.resume()
            return status
        case .denied:
            logger.debug("Camera access denied.")
            return false
        case .restricted:
            logger.debug("Camera library access restricted.")
            return false
        default:
            return false
        }
    }
    
    private func updateSessionForCaptureDevice(_ captureDevice: AVCaptureDevice) {
        guard isCaptureSessionConfigured else { return }
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }

        for input in captureSession.inputs {
            if let deviceInput = input as? AVCaptureDeviceInput {
                captureSession.removeInput(deviceInput)
            }
        }
        
        let deviceInput: AVCaptureDeviceInput
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error {
            logger.error("Error getting capture device input: \(error.localizedDescription)")
            return
        }
        
        if !captureSession.inputs.contains(deviceInput) && captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        }
    }
    
    private func deviceInputFor(device: AVCaptureDevice?) -> AVCaptureDeviceInput? {
        guard let validDevice = device else { return nil }
        do {
            return try AVCaptureDeviceInput(device: validDevice)
        } catch let error {
            logger.error("Error getting capture device input: \(error.localizedDescription)")
            return nil
        }
    }
    
    // FIXME: Using deprecated APIs
    private func videoOrientationFor(_ deviceOrientation: UIDeviceOrientation) -> AVCaptureVideoOrientation? {
        switch deviceOrientation {
        case .portrait: return AVCaptureVideoOrientation.portrait
        case .portraitUpsideDown: return AVCaptureVideoOrientation.portraitUpsideDown
        case .landscapeLeft: return AVCaptureVideoOrientation.landscapeRight
        case .landscapeRight: return AVCaptureVideoOrientation.landscapeLeft
        default: return nil
        }
    }
    
    func start() async {
        let authorized = await checkAuthorization()
        guard authorized else {
            logger.error("Camera access was not authorized.")
            return
        }
        
        // Already session configured
        if isCaptureSessionConfigured {
            if !captureSession.isRunning {
                sessionQueue.async { [self] in
                    self.captureSession.startRunning()
                }
            }
            return
        }
        
        // Not configured
        sessionQueue.async { [self] in
            self.configureCaptureSession { success in
                guard success else { return }
                self.captureSession.startRunning()
            }
        }
    }
    
    func stop() {
        guard isCaptureSessionConfigured else { return }
        
        if captureSession.isRunning {
            sessionQueue.async { [self] in
                self.captureSession.stopRunning()
            }
        }
    }
    
    func switchCaptureDevice() {
        if let captureDevice = captureDevice,
           let index = availableCaptureDevices.firstIndex(of: captureDevice) {
            let nextIndex = (index + 1) % availableCaptureDevices.count
            self.captureDevice = availableCaptureDevices[nextIndex]
        } else {
            self.captureDevice = AVCaptureDevice.default(for: .video)
        }
    }
    
    func startRecording() {
        guard let movieFileOutput = movieFileOutput,
              let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("video.mp4") else { return }
      if movieFileOutput.isRecording == false {
        if FileManager.default.fileExists(atPath: url.path) {
          try? FileManager.default.removeItem(at: url)
        }
        movieFileOutput.startRecording(to: url, recordingDelegate: self)
      }
    }

    func stopRecording() {
        guard let movieFileOutput = movieFileOutput else { return }
              
        if isRecording {
            movieFileOutput.stopRecording()
        }
    }
}

extension Camera: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }
        
        if connection.isVideoOrientationSupported,
           let videoOrientation = videoOrientationFor(deviceOrientation) {
            connection.videoOrientation = videoOrientation
        }
        
        addToPreviewStream?(CIImage(cvPixelBuffer: pixelBuffer))
    }
}

extension Camera: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        logger.debug("didFinishRecordingTo - \(outputFileURL)")
    }
}

fileprivate let logger = Logger(subsystem: "com.youngtaek.iOSStudy.Camera", category: "Camera")
