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
    
    private lazy var spawnNode = { self.childNode(withName: "Spawner_0") as? SpawnSKNode }()

    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // Set up user control
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spawn)))
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(clear)))

        // Set up scene physics
        self.physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
        
        // Set up rules
        if let ruleSystem = self.entity?.component(ofType: RulesComponent.self)?.ruleSystem {
        
            ruleSystem.add(GKRule(predicate: NSPredicate(format: "$updateCount.intValue < 10"), assertingFact: "updateCountIsLow" as NSObject, grade: 0.7))
            ruleSystem.add(GKRule(predicate: NSPredicate(format: "$updateCount.intValue == 7"), retractingFact: "updateCountIsLow" as NSObject, grade: 0.3))
            print("Setting up rules component \(ruleSystem.state)")
        }
    }
    
    @objc func spawn(_ tap: UITapGestureRecognizer) {
        
        if trackEntity == nil { trackEntity = spawnNode?.spawnEntityRobotAndReturn() }
        else { spawnNode?.spawnEntityRobot() }
    }
    
    @objc func clear(_ tap: UITapGestureRecognizer) {
        
        guard tap.state == .began else { return }
        
        trackEntity = nil
        spawnNode?.spawner?.kill(recycle: false)
        
        // Reset the rules component's update count.
        self.entity?.component(ofType: RulesComponent.self)?.updateCount = 0
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        spawnNode?.spawner?.update(deltaTime: deltaTime)
    }
}

var trackEntity: RobotEntity?

// MARK: - Spawn with entity

extension SpawnSKNode {
    
    func spawnEntityRobot() {
        
        spawn(name: "RobotNoG") { robotNode in
            
            let robotEntity = RobotEntity(track: trackEntity?.agent)

            robotEntity.addComponent(GKSKNodeComponent(node: robotNode))
            robotEntity.addComponent(AIComponent(states: [WanderState(entity: robotEntity), PhysicsState(entity: robotEntity), DebugState(name: "Burpleson")]))

            return robotEntity
        }
    }
    
    func spawnEntityRobotAndReturn() -> RobotEntity {
        
        let robotEntity = RobotEntity()

        spawn(name: "RobotNoG") { robotNode in
            
            robotEntity.addComponent(GKSKNodeComponent(node: robotNode))
            
            //robotEntity.addComponent(DebugComponent())
            //robotEntity.addComponent(DespawnNodeComponent(node: robotNode))
            
            return robotEntity
        }
        
        return robotEntity
    }
}
