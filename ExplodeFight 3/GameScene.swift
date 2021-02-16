//
//  GameScene.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 23/11/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons

class GameScene: BaseSKScene {
    
    override var requiredScaleMode: SKSceneScaleMode { .aspectFit }
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)

        // The scene will handle physics contacts itself.
        physicsWorld.contactDelegate = self
    }
    
    override func update(delta: TimeInterval) {
        
        super.update(delta: delta)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("Contact between \(contact.bodyA.node?.name) and \(contact.bodyB.node?.name)")
    }
}
