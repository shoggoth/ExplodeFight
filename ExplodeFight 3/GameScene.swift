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
    
    private lazy var spawnNode = { self.childNode(withName: "//SpawnRoot") as? SpawnSKNode }()

    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // Set up user control
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spawn)))
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(clear)))

        // Set up scene physics
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    @objc func spawn(_ tap: UITapGestureRecognizer) {
        
        spawnNode?.spawnMob(name: "Robot")
        spawnNode?.spawnMob(name: "RobotAnim")
    }
    
    @objc func clear(_ tap: UITapGestureRecognizer) {
        
        if tap.state == .began { spawnNode?.spawner?.kill(nodesWithName: "Robot", recycle: true) }
        if tap.state == .ended { spawnNode?.spawner?.kill(nodesWithName: "RobotAnim") }
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        spawnNode?.spawner?.update(deltaTime: deltaTime)
    }
}

// MARK: - Spawn from Spawn.sks

extension SpawnSKNode {
    
    func spawnMob(name: String) {
        
        spawn(name: name) { newNode in
            
            newNode.position = CGPoint(x: CGFloat.random(in: -500...500), y: CGFloat.random(in: -300...300))
            newNode.isPaused = false
            
            let entity = GKEntity()
            let dc = DebugComponent()
            dc.dumpTiming = false
            
            entity.addComponent(dc)
            
            return entity
        }
    }
}
