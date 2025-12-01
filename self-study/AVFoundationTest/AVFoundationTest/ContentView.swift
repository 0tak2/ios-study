//
//  ContentView.swift
//  AVFoundationTest
//
//  Created by 임영택 on 9/30/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .onAppear {
            let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes:
                [
                    .builtInWideAngleCamera,
                    .builtInUltraWideCamera,
                    .builtInTelephotoCamera,
                    .builtInDualWideCamera,
                    .builtInTripleCamera,
                    .builtInDualCamera,
                ],
                mediaType: .video, position: .unspecified)
            
            let devices = discoverySession.devices
            print(devices)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
