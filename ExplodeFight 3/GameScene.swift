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
    
    private let joystick = TouchJoystick()
    
    override func didMove(to view: SKView) {
        
        // Set up scene physics
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        // Setup entities
        if let node = scene?.childNode(withName: "Player") {
            
            let playerEntity = PlayerEntity(withNode: node)
            playerEntity.addComponent(PlayerControlComponent(joystick: joystick))

            entities.append(playerEntity)
        }
        if let node = scene?.childNode(withName: "Mob") { entities.append(PlayerEntity(withNode: node)) }
    }
}

// MARK: - Touch handling

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesBegan(touches, with: event) }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesMoved(touches, with: event) }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesEnded(touches, with: event) }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesCancelled(touches, with: event) }
}
