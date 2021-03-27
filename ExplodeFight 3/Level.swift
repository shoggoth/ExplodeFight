//
//  Level.swift
//  EF3
//
//  Created by Richard Henry on 12/03/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

class Level {
    
    private let scene: GameScene
    private let mobSpawner: SceneSpawner
    
    private var spawnRoot: SKNode { scene.childNode(withName: "SpawnRoot")! }

    init(scene: GameScene) {
        
        self.scene = scene
        
        // Global setup
        AppDelegate.soundManager.playNode = scene
        
        // Setup spawner
        mobSpawner = SceneSpawner(scene: SKScene(fileNamed: "Mobs")!)
        
        // Setup Player
        if let node = scene.childNode(withName: "Player") {
            
            let playerEntity = PlayerEntity(withNode: node)
            
            playerEntity.addComponent(PlayerControlComponent(joystick: scene.joystick))

            scene.entities.append(playerEntity)
        }
    }
    
    func update(deltaTime: TimeInterval) {

        mobSpawner.update(deltaTime: deltaTime)
    }
    
    func spawnMob() {
        
        let _ = mobSpawner.spawn(name: "Mob") { node in
            
            let mobEntity = MobEntity(withNode: node)
            
            node.position = CGPoint.zero
            node.isPaused = false
            
            mobEntity.addComponent(MobComponent(states: [
                                                    LiveState(),
                                                    ExplodeState {
                                                        AppDelegate.soundManager.playSound(name: "Explode")
                                                        (node as? SKSpriteNode)?.color = .white
                                                    },
                                                    DieState {
                                                        (node as? SKSpriteNode)?.color = .yellow
                                                        self.mobSpawner.spawner(named: "Mob")?.kill(node: node, recycle: true)
                                                    }]))
            
            mobEntity.addComponent(DebugComponent())
            
            self.spawnRoot.addChild(node)
            
            return mobEntity
        }
    }
}

// MARK: TODO: Temp (Move this to Level, levels might have different rules to one another.)

/* Set up rules
if let ruleSystem = rulesComponent?.ruleSystem {

    ruleSystem.add(GKRule(predicate: NSPredicate(format: "$updateCount.intValue < 10"), assertingFact: "updateCountIsLow" as NSObject, grade: 0.7))
    ruleSystem.add(GKRule(predicate: NSPredicate(format: "$updateCount.intValue == 7"), retractingFact: "updateCountIsLow" as NSObject, grade: 0.3))
}
 
 print("State \(ruleSystem.state)")
 print("Facts \(ruleSystem.facts) \(ruleSystem.grade(forFact: "mobCountIsLow" as NSObject))")

rulesComponent?.updateCount = 0
 */
