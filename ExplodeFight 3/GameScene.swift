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
    
    private lazy var spawnNode = { self.childNode(withName: "//Spawner_0") as? SpawnSKNode }()

    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // Set up user control
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spawn)))
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(clear)))

        // Set up scene physics
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // Spawn some robots
        (0..<300).forEach { _ in spawnNode?.spawnRobot() }
    }
    
    @objc func spawn(_ tap: UITapGestureRecognizer) {
        
        spawnField(loc: convertPoint(fromView: tap.location(in: view)))
    }
    
    @objc func clear(_ tap: UITapGestureRecognizer) {
        
        if tap.state == .began { spawnNode?.spawner?.kill(nodesWithName: "Robot", recycle: true) }
        if tap.state == .ended { spawnNode?.spawner?.kill(nodesWithName: "RobotAnim") }
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        spawnNode?.spawner?.update(deltaTime: deltaTime)
    }
    
    func spawnField(loc: CGPoint) {
        
        let shield = SKFieldNode.radialGravityField()
        shield.position = loc
        shield.strength = -5
        shield.categoryBitMask = 1
        shield.region = SKRegion(radius: 256)
        shield.falloff = 4
        shield.run(SKAction.sequence([.strength(to: 0, duration: 2.0), .removeFromParent()]))
        addChild(shield)
    }
}

// MARK: - Spawn without entity

extension SpawnSKNode {
    
    func spawnRobot() {
        
        spawn(name: "Robot") { newNode in
            
            newNode.position = CGPoint(x: CGFloat.random(in: -500...500), y: CGFloat.random(in: -300...300))
            newNode.isPaused = false
            
            newNode.removeAllChildren()
            
            return nil
        }
    }
}
