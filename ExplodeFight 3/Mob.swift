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
    
    let position: CGPoint
    let rotation: CGFloat
    
    func makeStates(node: SKNode, scene: GameScene, spawner: Spawner) -> [GKState] {
        
        let resetState = MobState.ResetState {
            
            node.reset { _ in
                
                node.zRotation = rotation
                node.position  = position
                node.isPaused = false
                
                // In case the explode action is still running...
                node.removeAction(forKey: "Explode_PixelShatter")
                
                if let node = node as? SKSpriteNode {
                    node.shader = nil
                    node.warpGeometry = nil
                }
            }
            
            return CountdownTimer(countDownTime: 30.0)
        }
        
        let explodeState = MobState.ExplodeState {
            
            if let node = node as? SKSpriteNode {
                
                // TODO: Decide which explosion suits best
                //node.removeAllActions()
                //Global.explodeShader.explode(node: node, toScale: vector_float2(7, 1), withSplits: vector_float2(16, 1), duration: 1)
                //Global.particleExploder.explode(node: node, duration: 1.0)
                //Global.explodeShader.rttExplode(node: node, toScale: vector_float2(7, 1), withSplits: vector_float2(16, 1), duration: 1)
                //Global.scoreCharSet.scoreFlyup(string: "HELLO", spacing: 5, parentNode: node)
                Global.explodeShader.explode(node: node, toScale: vector_float2(7, 1), withSplits: vector_float2(16, 1), duration: 1)
            }
            
            Global.soundManager.playSound(name: "Explode")
            
            return CountdownTimer(countDownTime: 1.0)
        }
        
        let dieState = MobState.DieState {
            
            scene.addScore(score: pointValue)
            spawner.kill(node: node, recycle: true)
        }
        
        return [resetState, explodeState, dieState]
    }
}
