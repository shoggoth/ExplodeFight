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
        
        if trackEntity == nil { trackEntity = spawnNode?.spawnEntityRobotAndReturn() }
        else { spawnNode?.spawnEntityRobot() }
    }
    
    @objc func clear(_ tap: UITapGestureRecognizer) {
        
        trackEntity = nil
        spawnNode?.spawner?.kill()
    }
    
    override func update(delta: TimeInterval) {
        
        super.update(delta: delta)
        
        spawnNode?.spawner?.update(delta: delta)
        trackEntity?.update(deltaTime: delta)
    }
}

var trackEntity: RobotEntity?

// MARK: - Spawn with entity

extension SpawnSKNode {
    
    func spawnEntityRobot() {
        
        spawn(name: "RobotNoG") { robotNode in
            
            let robotEntity = RobotEntity(track: trackEntity?.agent)

            robotEntity.addComponent(GKSKNodeComponent(node: robotNode))

            robotNode.position = CGPoint(x: (CGFloat(arc4random() % 100) - 50) * 0.0001, y: 0.0)

            return robotEntity
        }
    }
    
    func spawnEntityRobotAndReturn() -> RobotEntity {
        
        let robotEntity = RobotEntity()

        spawn(name: "RobotNoG") { robotNode in
            
            robotEntity.addComponent(GKSKNodeComponent(node: robotNode))
            
            //robotEntity.addComponent(DebugComponent())
            //robotEntity.addComponent(DespawnNodeComponent(node: robotNode))
            
            return nil
        }
        
        return robotEntity
    }
}
