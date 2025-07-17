//
//  CustomARView+.swift
//  SceneUnderstandingPractice
//
//  Created by 임영택 on 7/5/25.
//

import Foundation
import ARKit
import RealityKit

extension CustomARView {
    var postItSize: Float { 0.2 }
    var postItHeight: Float { 0.01 }
    var gameManager: GameManager {
        GameManager.instance
    }
    
    func attachToPlane() {
        //        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        //
        //        if let query = self.makeRaycastQuery(from: center, allowing: .existingPlaneGeometry, alignment: .any),
        //           let result = self.session.raycast(query).first,
        //           let anchorID = result.anchor?.identifier {
        //
        //            if let planeAnchor = self.session.currentFrame?.anchors.first(where: {
        //                $0.identifier == anchorID && $0 is ARPlaneAnchor
        //            }) as? ARPlaneAnchor {
        //                print("Plane anchor found: \(planeAnchor)")
        //                print("Center: \(planeAnchor.center), Extent: \(planeAnchor.planeExtent)")
        //
        //                attachModelEntitiesToPlane(to: planeAnchor, in: self)
        //            }
        //        }
        guard let anchors = self.session.currentFrame?.anchors else {
            print("There is no anchors in currentFrame")
            return
        }
        
        guard let totalCardCount = gameManager.totalCardCount else {
            print("gameManager not configured...")
            return
        }
        
        var iterationCount = 0
        let iterationCountMax = 10
        while gameManager.attachedCardsCount < totalCardCount
                && iterationCount < iterationCountMax {
            anchors.forEach { anchor in
                if let planeAnchor = anchor as? ARPlaneAnchor,
                   gameManager.attachedCardsCount < totalCardCount {
                    attachModelEntitiesToPlane(to: planeAnchor, in: self)
                    gameManager.cardsAttached()
                }
            }
            
            iterationCount += 1
        }
        
        print("observer: iterationCount=\(iterationCount) iterationCountMax=\(iterationCountMax) attachedCardsCount=\(gameManager.attachedCardsCount)")
    }
    
    /// 특정 평면 앵커에 특정 개수의 카드 엔티티를 부착하고, 부착한 카드 개수를 반환한다.
    func attachModelEntitiesToPlane(to planeAnchor: ARPlaneAnchor, in arView: ARView) {
        let planeExtent = planeAnchor.planeExtent
        guard planeExtent.width >= postItSize && planeExtent.height >= postItSize else {
            print("skip the plane because it is too small")
            return
        }
        
        let anchorEntity = AnchorEntity(anchor: planeAnchor)
        
        let widthRangeEnd = (planeExtent.width - postItSize) / 2
        let heightRangedEnd = (planeExtent.height - postItSize) / 2
        
        // 간단한 박스 모델 생성 (포스트잇 크기)
        let localX = Float.random(in: -widthRangeEnd...widthRangeEnd) // 원점을 기준으로 좌우
        let localY = Float.random(in: -heightRangedEnd...heightRangedEnd) // 원점을 기준으로 상하
        let localZ = Float(0.001) // 평면에서 살짝 앞으로 띄우기 => 수직 평면이므로 Y값을 조정하면 법선으로부터 튀어나오는 효과

        let modelEntity = CardEntity()
        
        // 로컬 위치를 평면 좌표계 기준으로 설정 (수직 평면)
        let localPosition = SIMD3<Float>(localX, localY, localZ)
        modelEntity.position = localPosition
        
        let beginEventSub = self.scene.subscribe(
            to: CollisionEvents.Began.self,
            on: modelEntity
        ) { [weak self] event in
            // 충돌이 감지되면 한 쪽 엔티티를 제거한다
            print("collision started")
            event.entityB.removeFromParent()
            GameManager.instance.cardDetached()
            
            if GameManager.instance.currentMode != .ready
                && GameManager.instance.attachedCardsCount < GameManager.instance.totalCardCount ?? 15 {
                self?.attachToPlane()
            }
        }
        modelEntity.entitySubs.append(beginEventSub)
        
        // Anchor에 AnchorEntity 연결
        anchorEntity.addChild(modelEntity)
        
        arView.scene.addAnchor(anchorEntity)
        print("added modelEntity")
    }
}
