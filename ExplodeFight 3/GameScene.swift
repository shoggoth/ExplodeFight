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
    
    var score = Score(dis: 0, acc: 0)
    
    var spawnTicker: PeriodicTimer? = PeriodicTimer(tickInterval: 1.7)
    let mobSpawner = SceneSpawner(scene: SKScene(fileNamed: "Mobs")!)

    private let joystick = TouchJoystick()
    private var level: Level?
    
    override func didMove(to view: SKView) {
        
        // Global setup
        AppDelegate.soundManager.playNode = self

        // Set up scene physics
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        // Setup Player
        if let node = childNode(withName: "Player"), let entity = node.entity {
            
            entity.addComponent(GKAgent2D(node: node, maxSpeed: 600, maxAcceleration: 20, radius: 20, mass: Float(node.physicsBody?.mass ?? 1)))
            entity.addComponent(PlayerControlComponent(joystick: joystick))
        }

        // Create initial level
        level = Level()
    }
    
    override func update(deltaTime: TimeInterval) {
        
        mobSpawner.update(deltaTime: deltaTime)
        level?.update(deltaTime: deltaTime, scene: self)
        
        if score.acc > 0 {
            
            score = score.tick()
            (childNode(withName: "Camera/Score") as? SKLabelNode)?.text = "SCORE: \(score.dis)"
            
            // ScoreManager.updateChieve(id: "millionaire", percent: 100)
        }
        

        super.update(deltaTime: deltaTime)
    }
    
    func addScore(score s: Int64) {
        
        score = score.add(add: s)
    }
}

// MARK: - Button press handling -

extension GameScene: ButtonSKSpriteNodeResponder {
    
    func buttonTriggered(button: ButtonSKSpriteNode) {
        
        isPaused = !isPaused
    }
}

// MARK: - Contact handling -

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let a = contact.bodyA.node, let b = contact.bodyB.node else { return }
        
        a.contactWithNodeDidBegin(b)
        b.contactWithNodeDidBegin(a)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        guard let a = contact.bodyA.node, let b = contact.bodyB.node else { return }

        a.contactWithNodeDidEnd(b)
        b.contactWithNodeDidEnd(a)
    }
}

// MARK: - Touch handling -

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesBegan(touches, with: event) }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesMoved(touches, with: event) }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesEnded(touches, with: event) }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesCancelled(touches, with: event) }
}
