//
//  ViewController.swift
//  MapKitPractice
//
//  Created by 임영택 on 3/1/25.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    private let mapView = MKMapView()
    private let controlView = MapControlView()
    private let initialLocation = CLLocation(latitude: 37.559975221378, longitude: 126.975312652739)
    private var regionRadius = 1000.0
    private let zoomFactor = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Map View
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        mapView.centerToLocation(initialLocation, regionRadius: regionRadius)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        // MARK: Control View
        controlView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controlView)
        NSLayoutConstraint.activate([
            controlView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            controlView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            controlView.widthAnchor.constraint(equalToConstant: 48),
            controlView.heightAnchor.constraint(equalToConstant: 96),
        ])
        
        controlView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        controlView.minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
    }
}

extension ViewController {
    @objc private func plusButtonTapped() {
        adjustZoomLevel(to: .zoomIn)
    }
    
    @objc private func minusButtonTapped() {
        adjustZoomLevel(to: .zoomOut)
    }
    
    private func adjustZoomLevel(to direction: ZoomDirection) {
        var region = mapView.region

        if direction == .zoomIn {
            region.span.latitudeDelta *= zoomFactor
            region.span.longitudeDelta *= zoomFactor
        } else {
            region.span.latitudeDelta /= zoomFactor
            region.span.longitudeDelta /= zoomFactor
        }

        mapView.setRegion(region, animated: true)
    }
    
    private enum ZoomDirection {
        case zoomIn
        case zoomOut
    }
}

private extension MKMapView {
    func centerToLocation (_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        
        self.setRegion(coordinateRegion, animated: true)
    }
}
