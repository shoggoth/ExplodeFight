//
//  AIComponent.swift
//  EF3
//
//  Created by Richard Henry on 17/06/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

class AIComponent: GKComponent {
    
    var thinkTimer: PeriodicTimer? = PeriodicTimer(tickInterval: 1)
    
    override func update(deltaTime: TimeInterval) {
        
        guard let scene = (entity?.spriteComponent?.node.scene as? GameScene) else { return }
        guard let snapshot = scene.level?.snapshot else { return }

        thinkTimer = thinkTimer?.tick(deltaTime: deltaTime) {
            
            if snapshot.mobEntities.count > 24 { stopMoving() }
            
            if let ppos = scene.player?.position, let epos = entity?.spriteComponent?.node.position {
                
                if abs(hypotf(Float(epos.x - ppos.x), Float(epos.y - ppos.y))) < 100 { stopMoving() }
            }
        }

        super.update(deltaTime: deltaTime)
    }
    
    private func stopMoving() {
        
        entity?.component(ofType: GKAgent2D.self)?.behavior = GKBehavior(goal: GKGoal(toReachTargetSpeed: 0), weight: 10.0)
    }
}
