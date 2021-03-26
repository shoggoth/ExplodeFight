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
    private let ruleSystem: GKRuleSystem = GKRuleSystem()

    private var explodeAction = SKAction.playSoundFileNamed("Explode.caf", waitForCompletion: false)

    private var spawnTicker: PeriodicTimer? = PeriodicTimer(tickInterval: 3.0)

    init(scene: GameScene) {
        
        self.scene = scene
        
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
        
        let _ = mobSpawner.spawn(name: "Mob") { node in
            
            let mobEntity = MobEntity(withNode: node)
            
            node.position = CGPoint.zero
            
            mobEntity.addComponent(MobComponent(states: [
                                                    LiveState(),
                                                    ExplodeState {
                                                        self.scene.run(self.explodeAction)
                                                        (node as? SKSpriteNode)?.color = .white
                                                        print("exploding")
                                                    },
                                                    DieState {
                                                        (node as? SKSpriteNode)?.color = .yellow
                                                        self.mobSpawner.spawner(named: "Mob")?.kill(node: node, recycle: true)
                                                    },
                                                    DebugState(name: "Anon")]))
            
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
