//
//  GameScene.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 23/11/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons
import GameplayKit
import GameControls

class GameScene: BaseSKScene {
    
    override var requiredScaleMode: SKSceneScaleMode { .aspectFit }
    
    let joystick = TouchJoystick()
    var level: Level?
    
    override func didMove(to view: SKView) {
        
        // Set up scene physics
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        // Create initial level
        level = Level(scene: self)
    }
    
    override func update(deltaTime: TimeInterval) {
        
        level?.update(deltaTime: deltaTime)
        
        super.update(deltaTime: deltaTime)
    }
}

extension GameScene: ButtonSKSpriteNodeResponder {
    
    func buttonTriggered(button: ButtonSKSpriteNode) {
        
        switch button.name {
        case "spawnButton":
            level?.spawnMob()
        default:
            fatalError("Button wut?")
        }
    }
}

// MARK: - Contact handling -

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        (contact.bodyA.node?.entity as? ContactNotifiable)?.contactWithEntityDidBegin(contact.bodyB.node?.entity ?? GKEntity())
        (contact.bodyB.node?.entity as? ContactNotifiable)?.contactWithEntityDidBegin(contact.bodyA.node?.entity ?? GKEntity())
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        (contact.bodyA.node?.entity as? ContactNotifiable)?.contactWithEntityDidEnd(contact.bodyB.node?.entity ?? GKEntity())
        (contact.bodyB.node?.entity as? ContactNotifiable)?.contactWithEntityDidEnd(contact.bodyA.node?.entity ?? GKEntity())
    }
}
// MARK: - Touch handling -

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesBegan(touches, with: event) }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesMoved(touches, with: event) }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesEnded(touches, with: event) }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesCancelled(touches, with: event) }
}
