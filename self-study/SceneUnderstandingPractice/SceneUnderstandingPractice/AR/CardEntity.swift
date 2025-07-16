//
//  CardEntity.swift
//  SceneUnderstandingPractice
//
//  Created by 임영택 on 7/14/25.
//

import Foundation
import UIKit
import RealityKit
import Combine

/// ref: https://maxxfrazer.medium.com/realitykit-events-97964fa5b5c7
class CardEntity: Entity, HasModel, HasCollision, HasAnchoring {
    static let postItSize: Float = 0.2
    static let postItDepth: Float = 0.01
    
    /// Used to keeping a reference of any subscriptions involving this entity
    var entitySubs: [Cancellable] = []
    
    required init(color: UIColor) {
        super.init()
        
        // Shape of this entity for any collisions including gestures
        self.components[CollisionComponent.self] = CollisionComponent(
            shapes: [.generateBox(size: [CardEntity.postItSize, CardEntity.postItDepth, CardEntity.postItSize])],
            mode: .trigger,
            filter: .sensor
        )
        
        // Model of this entity, the physical appearance is a 1x0.2x1 cuboid
        self.components[ModelComponent.self] = ModelComponent(
            mesh: .generateBox(size: [CardEntity.postItSize, CardEntity.postItDepth, CardEntity.postItSize]),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: false)
            ]
        )
        
        self.components[LearningCardComponent.self] = LearningCardComponent()
    }
    
    convenience init(color: UIColor, position: SIMD3<Float>) {
        self.init(color: color)
        self.position = position
    }
    
    required convenience init() {
        self.init(color: .orange)
    }
}
