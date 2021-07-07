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
    
    override var requiredScaleMode: SKSceneScaleMode { UIScreen.main.traitCollection.userInterfaceIdiom == .pad ? .aspectFill : .aspectFit }
    
    private lazy var spawnNode = { self.childNode(withName: "//SpawnRoot") as? SpawnSKNode }()

    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
            
            self.childNode(withName: "//Camera")?.setScale(1.33333)
        }

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
            
            let w = (self.scene?.size.width ?? 320.0) * 0.5
            let h = (self.scene?.size.height ?? 200.0) * 0.5

            newNode.position = CGPoint(x: CGFloat.random(in: -w...w), y: CGFloat.random(in: -h...h))
            newNode.isPaused = false
            
            let entity = GKEntity()
            let dc = DebugComponent()
            dc.dumpTiming = false
            
            entity.addComponent(dc)
            
            return entity
        }
    }
}
