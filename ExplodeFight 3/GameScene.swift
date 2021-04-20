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

// MARK: - Contact handling -

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let a = contact.bodyA.node?.entity, let b = contact.bodyB.node?.entity else { return }
        
        (a as? ContactNotifiable)?.contactWithEntityDidBegin(b)
        (b as? ContactNotifiable)?.contactWithEntityDidBegin(a)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        guard let a = contact.bodyA.node?.entity, let b = contact.bodyB.node?.entity else { return }
        
        (a as? ContactNotifiable)?.contactWithEntityDidEnd(b)
        (b as? ContactNotifiable)?.contactWithEntityDidEnd(a)
    }
}

protocol ContactNotifiable {

    func contactWithEntityDidBegin(_ entity: GKEntity)
    
    func contactWithEntityDidEnd(_ entity: GKEntity)
}

// MARK: - Touch handling -

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesBegan(touches, with: event) }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesMoved(touches, with: event) }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesEnded(touches, with: event) }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesCancelled(touches, with: event) }
}
