//
//  CustomARView+Persistence.swift
//  SceneUnderstandingPractice
//
//  Created by 임영택 on 7/3/25.
//

import ARKit
import RealityKit

/// see: https://developer.apple.com/documentation/arkit/arworldmap#Serialize-and-Deserialize-a-World-Map
extension CustomARView {
    var mapDataFromFile: Data? {
        return try? Data(contentsOf: mapSaveURL)
    }
    
    func saveMap() {
        print("saveMap called")
        
        self.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap else {
                print("Can't get current world map... \(error!.localizedDescription)")
                return
            }
            
            print("map anchors: ")
            map.anchors.forEach { anchor in
                print(anchor)
            }
            
            print("session anchors: ")
            self.session.currentFrame?.anchors.forEach { anchor in
                print(anchor)
                
                map.anchors.append(anchor)
            }
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                try data.write(to: self.mapSaveURL, options: [.atomic])
                
                print("saveMap will be end")
            } catch {
                fatalError("Can't save map: \(error.localizedDescription)")
            }
        }
    }
    
    func loadMap() {
        let worldMap: ARWorldMap = {
            guard let data = mapDataFromFile
            else { fatalError("Map data should already be verified to exist before Load button is enabled.") }
            do {
                guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
                else { fatalError("No ARWorldMap in archive.") }
                return worldMap
            } catch {
                fatalError("Can't unarchive ARWorldMap from file data: \(error)")
            }
        }()
        
        print("anchors of loaded map: ")
        worldMap.anchors.forEach{ print($0) }
        
        resetSession(initialWorldMap: worldMap)
    }
}
