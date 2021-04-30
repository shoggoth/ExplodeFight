//
//  Mob.swift
//  EF3
//
//  Created by Richard Henry on 30/04/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

struct Mob {
    
    static let explodeShader = ExplodeShader(shaderName: "explode.fsh")

    static func spawn(mobName: String, scene: GameScene, spawner: SceneSpawner) {
        
        let _ = spawner.spawn(name: mobName) { node in
            
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
                    Mob.explodeShader.explode(node: node, toScale: vector_float2(7, 1), withSplits: vector_float2(16, 1), duration: 1)
                }
                
                AppDelegate.soundManager.playSound(name: "Explode")
                
                return CountdownTimer(countDownTime: 1.0)
            }
            
            let dieState = MobState.DieState {
                
                scene.addScore(score: 100)
                spawner.spawner(named: mobName)?.kill(node: node, recycle: true)
            }
            
            mobEntity.addComponent(MobComponent(states: [livestate, explodeState, dieState]))
            
            scene.addChild(node)

            return mobEntity
        }
    }
}
