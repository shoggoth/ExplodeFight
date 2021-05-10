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
    
    let name: String
    let maxSpeed: Float
    let pointValue: Int64
}

extension Spawner {
    
    func spawn(desc: Mob, scene: GameScene) -> SKNode? {
        
        spawn() { node in
            
            let mobEntity = GKEntity()
            
            mobEntity.addComponent(GKSKNodeComponent(node: node))
            mobEntity.addComponent(GKAgent2D(node: node, maxSpeed: desc.maxSpeed, maxAcceleration: 20, radius: 20, mass: Float(node.physicsBody?.mass ?? 1), behaviour: GKBehavior(goal: GKGoal(toWander: Float.random(in: -1.0 ... 1.0) * 600), weight: 100.0)))

            let livestate = MobState.LiveState {
                
                node.reset { _ in
                    
                    node.zRotation = CGFloat(Float.random(in: 0.0 ... Float.pi * 2.0))
                    node.position  = CGPoint.zero
                    node.isPaused = false
                    
                    node.removeAction(forKey: "Explode_PixelShatter")
                    (node as? SKSpriteNode)?.shader = nil
                }
                
                return CountdownTimer(countDownTime: 30.0)
            }
            
            let explodeState = MobState.ExplodeState {
                
                if let node = node as? SKSpriteNode {
                    
                    node.removeAllActions()
                    Global.explodeShader.explode(node: node, toScale: vector_float2(7, 1), withSplits: vector_float2(16, 1), duration: 1)
                }
                
                Global.soundManager.playSound(name: "Explode")
                
                return CountdownTimer(countDownTime: 1.0)
            }
            
            let dieState = MobState.DieState {
                
                scene.addScore(score: desc.pointValue)
                self.kill(node: node, recycle: true)
            }
            
            mobEntity.addComponent(MobComponent(states: [livestate, explodeState, dieState]))

            return mobEntity
        }
    }
}
