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
    private let explodeShader = ExplodeShader(shaderName: "explode.fsh")
    private let ruleSystem: GKRuleSystem = GKRuleSystem()

    private var spawnTicker: PeriodicTimer? = PeriodicTimer(tickInterval: 3.0)

    init(scene: GameScene) {
        
        self.scene = scene
        
        // Global setup
        AppDelegate.soundManager.playNode = scene
        
        // Setup spawner
        mobSpawner = SceneSpawner(scene: SKScene(fileNamed: "Mobs")!)
        
        // Setup level rules
        ruleSystem.add(GKRule(predicate: NSPredicate(format: "$mobCount.intValue < 10"), assertingFact: "mobCountIsLow" as NSObject, grade: 1.0))
        ruleSystem.add(GKRule(predicate: NSPredicate(format: "$mobCount.intValue == 0"), assertingFact: "allMobsDestroyed" as NSObject, grade: 1.0))

        // Setup Player
        if let node = scene.childNode(withName: "Player") {
            
            let playerEntity = PlayerEntity(withNode: node)
            
            playerEntity.addComponent(PlayerControlComponent(joystick: scene.joystick))

            scene.entities.append(playerEntity)
        }
    }
    
    func update(deltaTime: TimeInterval) {

        mobSpawner.update(deltaTime: deltaTime)
        
        ruleSystem.reset()
        ruleSystem.state["mobCount"] = mobSpawner.activeCount
        ruleSystem.evaluate()
        
        // TODO: Move this elsewhere
        if ruleSystem.grade(forFact: "mobCountIsLow" as NSObject) >= 1.0 {
                        
            spawnTicker = spawnTicker?.tick(deltaTime: deltaTime) { spawnTemp() }
        }
    }
    
    func spawnTemp() {
        
        let mobName = "Ship"
        
        let _ = mobSpawner.spawn(name: mobName) { node in
            
            let mobEntity = MobEntity(withNode: node)
            
            node.position = CGPoint.zero

            mobEntity.addComponent(MobComponent(states: [
                                                    LiveState(),
                                                    ExplodeState {
                                                        AppDelegate.soundManager.playSound(name: "Explode")
                                                        
                                                        if let node = node as? SKSpriteNode {
                                                            
                                                            node.color = .white
                                                            self.explodeShader.explode(node: node, toScale: vector_float2(2, 1), withSplits: vector_float2(2, 1), duration: 3)
                                                        }
                                                    },
                                                    DieState {
                                                        if let node = node as? SKSpriteNode {
                                                            
                                                            node.shader = nil
                                                            node.color = .yellow
                                                        }
                                                        
                                                        self.mobSpawner.spawner(named: mobName)?.kill(node: node, recycle: true)
                                                    }]))
            
            //mobEntity.addComponent(DebugComponent())
            
            self.scene.addChild(node)
            
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
