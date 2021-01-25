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
        self.physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
    }
    
    @objc func spawn(_ tap: UITapGestureRecognizer) {
        
        spawnNode?.spawnMultiRobots()
    }
    
    @objc func clear(_ tap: UITapGestureRecognizer) {
        
        spawnNode?.spawner?.kill()
    }
    
    override func update(delta: TimeInterval) {
        
        super.update(delta: delta)
        
        spawnNode?.spawner?.update(delta: delta)
    }
}

// MARK: - Spawn without entity

extension SpawnSKNode {
    
    func spawnMultiRobots(count: Int = 25) {
        
        (0..<count).forEach { _ in spawn(name: "Robot") { newNode in
            
            newNode.position = CGPoint(x: CGFloat(arc4random() % 100) - 50, y: CGFloat(arc4random() % 200) - 100)
            newNode.run(SKAction.repeatForever(SKAction(named: "Pulse")!))
            newNode.isPaused = false
            
            return nil
            }
        }
        
        (0..<count).forEach { _ in spawn(name: "RobotAnim") { newNode in
            
            newNode.position = CGPoint(x: CGFloat(arc4random() % 200) - 100, y: CGFloat(arc4random() % 100) - 50)
            newNode.isPaused = false
            
            return nil
            }
        }
    }
}
