//
//  Level.swift
//  EF3
//
//  Created by Richard Henry on 12/03/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

class NewLevel {
    
    private let scene: BaseSKScene

    init(scene: BaseSKScene) {
        
        self.scene = scene
    }
}

class Level {
    
    private let scene: BaseSKScene
    private let spawner: SceneSpawner
    private var spawnTicker: PeriodicTimer?
    private var killTicker: PeriodicTimer?

    init(scene: BaseSKScene) {
        
        self.scene = scene
        
        // Setup spawner
        spawner = SceneSpawner(scene: scene)
        spawnTicker = PeriodicTimer(tickInterval: 1.0)
        killTicker = PeriodicTimer(tickInterval: 10.0)

        // TODO: Temp
        setup()
    }
    
    func update(deltaTime: TimeInterval) {
        
        spawner.update(deltaTime: deltaTime)
        
        killTicker = killTicker?.tick(deltaTime: deltaTime) {
            
            spawner.kill()
        }
        
        spawnTicker = spawnTicker?.tick(deltaTime: deltaTime) {
            
            scene.addChild(spawner.spawn(name: "Mob") { node in
                
                node.position = CGPoint.zero
                
                return MobEntity(withNode: node)
            }!)
        }
    }
    
    private func setup() {
        
        // Setup entities
        if let node = scene.childNode(withName: "Player") {
            
            let playerEntity = PlayerEntity(withNode: node)
            //playerEntity.addComponent(PlayerControlComponent(joystick: joystick))

            scene.entities.append(playerEntity)
        }
        
        if let node = scene.childNode(withName: "Mob") { scene.entities.append(MobEntity(withNode: node)) }
        
        (1...10).forEach { _ in
            
            if let node = spawner.spawn(name: "Mob") {
                
                let mobEntity = MobEntity(withNode: node)
                
                scene.addChild(node)
                scene.entities.append(MobEntity(withNode: node))
            }
        }
    }
}

// MARK: TODO: Temp (Move this to Level, levels might have different rules to one another.)

/* Set up rules
if let ruleSystem = rulesComponent?.ruleSystem {

    ruleSystem.add(GKRule(predicate: NSPredicate(format: "$updateCount.intValue < 10"), assertingFact: "updateCountIsLow" as NSObject, grade: 0.7))
    ruleSystem.add(GKRule(predicate: NSPredicate(format: "$updateCount.intValue == 7"), retractingFact: "updateCountIsLow" as NSObject, grade: 0.3))
}

rulesComponent?.updateCount = 0
 */
