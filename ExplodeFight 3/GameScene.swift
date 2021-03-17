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
    
    private lazy var sceneNode = { self.childNode(withName: "Original") }()
    private lazy var spawnNode = { self.childNode(withName: "//Spawner_0") as? SpawnSKNode }()
    
    private var spawner: Spawner?
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // Set up user control
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spawn)))
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(clear)))
        
        // Set up scene physics
        self.physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
        
        spawner = Spawner(node: sceneNode!)
        //spawner?.autoAddSpriteComponent = true
    }
    
    func removeSceneNode() {
        
        if let entity = sceneNode?.entity, let i = entities.firstIndex(of: entity) { entities.remove(at: i) }
    }
    
    @objc func spawn(_ tap: UITapGestureRecognizer) {
        
        if let node = spawner?.spawn(completion: { node in
            
            let entity = GKEntity()
            
            //entity.addComponent(GKSKNodeComponent(node: node))
            entity.addComponent(DebugComponent())
            
            return entity
        }) {
            
            node.physicsBody = SKPhysicsBody(circleOfRadius: 16)
            addChild(node)
        }
        
        spawnNode?.spawnMultiRobots()
    }
    
    @objc func clear(_ tap: UITapGestureRecognizer) {
        
        if tap.state == .began {
            
            removeSceneNode()
            
            spawnNode?.spawner?.kill(nodesWithName: "RobotAnim")
            spawner?.kill()
        }
        
        else if tap.state == .ended {
            
            sceneNode?.removeFromParent()
            
            spawnNode?.spawner?.kill(nodesWithName: "Robot")
        }
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        spawner?.update(deltaTime: deltaTime)
        spawnNode?.spawner?.update(deltaTime: deltaTime)
    }
}

// MARK: - Spawn robots -

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
