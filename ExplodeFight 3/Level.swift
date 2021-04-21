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

    private var score = Score(dis: 0, acc: 0)
    private var spawnTicker: PeriodicTimer? = PeriodicTimer(tickInterval: 1.7)

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
        if let node = scene.childNode(withName: "Player"), let entity = node.entity {
            
            entity.addComponent(GKAgent2D(node: node, maxSpeed: 600, maxAcceleration: 20, radius: 20, mass: Float(node.physicsBody?.mass ?? 1)))
            entity.addComponent(PlayerControlComponent(joystick: scene.joystick))
        }
    }
    
    func update(deltaTime: TimeInterval) {

        // Do updates
        mobSpawner.update(deltaTime: deltaTime)
        
        score = score.tick()
        (scene.childNode(withName: "Camera/Score") as? SKLabelNode)? .text = "SCORE: \(score.tick().dis)"
        
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
            
            let mobEntity = GKEntity()
            
            mobEntity.addComponent(GKSKNodeComponent(node: node))
            mobEntity.addComponent(GKAgent2D(node: node, maxSpeed: 600, maxAcceleration: 20, radius: 20, mass: Float(node.physicsBody?.mass ?? 1), behaviour: GKBehavior(goal: GKGoal(toWander: Float.random(in: -1.0 ... 1.0) * 600), weight: 100.0)))

            let livestate = MobState.LiveState {
                
                if let node = node as? SKSpriteNode {
                    
                    node.zRotation = CGFloat(Float.random(in: 0.0 ... Float.pi * 2.0))
                    node.position = CGPoint.zero
                    node.shader = nil
                    node.xScale = 1.0
                    node.yScale = 1.0
                }
                
                return CountdownTimer(countDownTime: 30.0)
            }
            
            let explodeState = MobState.ExplodeState {
                
                if let node = node as? SKSpriteNode {
                    
                    node.isPaused = false
                    self.explodeShader.explode(node: node, toScale: vector_float2(7, 1), withSplits: vector_float2(16, 1), duration: 1)
                }
                
                //AppDelegate.soundManager.playSound(name: "Explode")
                
                return CountdownTimer(countDownTime: 1.0)
            }
            
            let dieState = MobState.DieState {
                
                self.score = self.score.add(add: 100)
                self.mobSpawner.spawner(named: mobName)?.kill(node: node, recycle: true)
            }
            
            mobEntity.addComponent(MobComponent(states: [livestate, explodeState, dieState]))
            
            self.scene.addChild(node)

            return mobEntity
        }
    }
}
