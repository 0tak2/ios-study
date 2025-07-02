//
//  ContentView.swift
//  TerrariumGA
//
//  Created by 임영택 on 7/2/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @State private var enlarge = false

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                content.add(scene)
                
                guard let audioEntity = scene.findEntity(named: "SpatialGrassAudio") else {
                    return
                }
                
                guard let audioSource = try? await AudioFileResource(named: "/Root/Atmospheres_Grasslands", from: "Scene.usda", in: realityKitContentBundle) else { // 리컴프의 하이어아키에서 확인
                    return
                }
                
                let audioPlaybackConroller = audioEntity.prepareAudio(audioSource)
                audioPlaybackConroller.play()
            }
        } update: { content in
            // Update the RealityKit content when SwiftUI state changes
            if let scene = content.entities.first {
                let uniformScale: Float = enlarge ? 1.4 : 1.0
                scene.transform.scale = [uniformScale, uniformScale, uniformScale]
            }
        }
        .gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
            enlarge.toggle()
        })
        .toolbar {
            ToolbarItemGroup(placement: .bottomOrnament) {
                VStack (spacing: 12) {
                    Button {
                        enlarge.toggle()
                    } label: {
                        Text(enlarge ? "Reduce RealityView Content" : "Enlarge RealityView Content")
                    }
                    .animation(.none, value: 0)
                    .fontWeight(.semibold)

                    ToggleImmersiveSpaceButton()
                }
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
        .environment(AppModel())
}
