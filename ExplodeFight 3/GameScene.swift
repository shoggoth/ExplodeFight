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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    @objc func tapped(_ tap: UITapGestureRecognizer) {
        
        spawnNode?.testNodeSpawn()
    }
    
    override func update(delta: TimeInterval) {
        
        super.update(delta: delta)
    }
}

extension SpawnSKNode {
    
    func testEntitySpawn() {
        
        spawn(name: "Robot") { robotNode in
            
            let robotEntity = GKEntity()
            
            //robotEntity.addComponent(DebugComponent())
            //robotEntity.addComponent(GKSKNodeComponent(node: robotNode))
            //robotEntity.addComponent(RopeComponent())
            //robotEntity.addComponent(ScannerComponent())
            
            return robotEntity
        }
    }
    
    func testEntitySpawn2() -> GKEntity {
        
        let robotEntity = GKEntity()

        spawn(name: "Robot") { robotNode in
            
            //robotEntity.addComponent(DespawnNodeComponent(node: robotNode))
            //robotEntity.addComponent(RopeComponent())
            //robotEntity.addComponent(ScannerComponent())
            //robotEntity.addComponent(DebugComponent())
            
            return nil
        }
        
        return robotEntity
    }
    
    func testNodeSpawn() {
        
        let amount = 25
        
        (0..<amount).forEach { _ in spawn(name: "Robot") { newNode in
            
            newNode.position = CGPoint(x: CGFloat(arc4random() % 100) - 50, y: CGFloat(arc4random() % 200) - 100)
            newNode.run(SKAction.repeatForever(SKAction(named: "Pulse")!))
            newNode.physicsBody = SKPhysicsBody(circleOfRadius: 3)
            newNode.isPaused = false
            
            return nil
            }
        }
        
        (0..<amount).forEach { _ in spawn(name: "RobotAnim") { newNode in
            
            newNode.position = CGPoint(x: CGFloat(arc4random() % 200) - 100, y: CGFloat(arc4random() % 100) - 50)
            newNode.isPaused = false
            
            return nil
            }
        }
    }
}
