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
    
    private lazy var spawner = { SceneSpawner(scene: SKScene(fileNamed: "Spawn")!) }()

    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // Set up user control
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spawn)))
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(clear)))

        // Set up scene physics
        self.physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
    }
    
    @objc func spawn(_ tap: UITapGestureRecognizer) {
        
        if let node = self.childNode(withName: ["Spawn_0", "Spawn_1", "Spawn_2", "Spawn_3"].randomElement()!) { spawner.spawnMultiRobots(on: node) }
    }
    
    @objc func clear(_ tap: UITapGestureRecognizer) {
        
        if tap.state == .began { spawner.kill(nodesWithName: "RobotAnim") }
        if tap.state == .ended { spawner.kill(nodesWithName: "Robot") }
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        spawner.update(deltaTime: deltaTime)
    }
}

// MARK: - Spawn without entity

extension SceneSpawner {
    
    func spawnMultiRobots(on node: SKNode, count: Int = 25) {
        
        (0..<count).forEach { _ in
            
            if let child = (spawn(name: "Robot") { newNode in
            
            newNode.position = CGPoint(x: CGFloat(arc4random() % 100) - 50, y: CGFloat(arc4random() % 200) - 100)
            newNode.run(SKAction.repeatForever(SKAction(named: "Pulse")!))
            newNode.isPaused = false
            
            return nil
            }) { node.addChild(child) }
        }
        
        (0..<count).forEach { _ in
            
            if let child = (spawn(name: "RobotAnim") { newNode in
            
            newNode.position = CGPoint(x: CGFloat(arc4random() % 200) - 100, y: CGFloat(arc4random() % 100) - 50)
            newNode.isPaused = false
            
            return nil
            }) { node.addChild(child) }
        }
    }
}
