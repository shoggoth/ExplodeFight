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

    private var spawnTicker: PeriodicTimer? = PeriodicTimer(tickInterval: 0.7)

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
            
            mobEntity.addComponent(MobComponent(states: [
                                                    LiveState {
                                                        if let node = node as? SKSpriteNode {
                                                            
                                                            node.position = CGPoint.zero
                                                            node.isPaused = false
                                                            node.shader = nil
                                                            node.xScale = 1.0
                                                            node.yScale = 1.0
                                                        }
                                                        
                                                        return CountdownTimer(countDownTime: 3.0)
                                                    },
                                                    ExplodeState {
                                                        if let node = node as? SKSpriteNode {
                                                            
                                                            self.explodeShader.explode(node: node, toScale: vector_float2(7, 1), withSplits: vector_float2(16, 1), duration: 1)
                                                        }
                                                        
                                                        //AppDelegate.soundManager.playSound(name: "Explode")
                                                        
                                                        return CountdownTimer(countDownTime: 1.0)
                                                    },
                                                    DieState {
                                                        self.mobSpawner.spawner(named: mobName)?.kill(node: node, recycle: true)
                                                    }]))
            
            //mobEntity.addComponent(DebugComponent())
            
            self.scene.addChild(node)

            return mobEntity
        }
    }
}
