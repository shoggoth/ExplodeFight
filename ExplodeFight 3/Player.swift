//
//  Player.swift
//  EF3
//
//  Created by Richard Henry on 28/05/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

struct Player {
    
    static func createPlayer(scene: GameScene) {
        
        if let node = { SKScene(fileNamed: "Players")?.orphanedChildNode(withName: "Player") }() {
            
            scene.playerEntity = {
                
                let entity = GKEntity()
                
                entity.addComponent(GKSKNodeComponent(node: node))
                entity.addComponent(GKAgent2D(node: node, maxSpeed: 600, maxAcceleration: 20, radius: 20, mass: Float(node.physicsBody?.mass ?? 1)))
                entity.addComponent(PlayerControlComponent(joystick: scene.joystick))
                entity.addComponent(StateComponent(states: Player.makeStates(node: node, scene: scene)))
                entity.addComponent(DebugComponent())
                entity.addComponent(ContactComponent { node in

                    if node.physicsBody?.categoryBitMask ?? 0 | 4 != 0 { print("Player picking up something.") }
                    if node.name == "Ship" { entity.component(ofType: StateComponent.self)?.stateMachine.enter(PlayerState.ExplodeState.self) }
                })
                entity.addComponent({
                    let fc = FireComponent()
                    fc.weaponType = Int.random(in: 1...4)
                    fc.fireRate = 0.5
                    return fc
                }())

                scene.entities.append(entity)

                return entity
            }()
            
            scene.playerRootNode.addChild(node)
        }
    }
    
    static func destroyPlayer(scene: GameScene) {
        
        if let e = scene.playerEntity, let i = scene.entities.firstIndex(of: e) { scene.entities.remove(at: i) }
        
        scene.playerRootNode.removeAllChildren()
    }
    
    private static func makeStates(node: SKNode, scene: GameScene) -> [GKState] {
        
        let resetState = PlayerState.ResetState {
            
            node.reset { _ in
                
                node.run(.fadeIn(withDuration: 0.23))

                node.isPaused = false
                node.isHidden = false

                // In case the explode action is still running...
                node.removeAction(forKey: "Explode_PixelShatter")
                
                if let node = node as? SKSpriteNode {
                    node.shader = nil
                    node.warpGeometry = nil
                }
            }
            
            return CountdownTimer(countDownTime: 30.0)
        }
        
        let playState = PlayerState.PlayState()
        
        let explodeState = PlayerState.ExplodeState {
            
            if let node = node as? SKSpriteNode {
                
                // TODO: Decide which explosion suits best
                Global.particleExploder.explode(node: node, duration: 1.0)
                node.run(.fadeOut(withDuration: 1.0))
                //Global.explodeShader.explode(node: node, toScale: vector_float2(7, 1), withSplits: vector_float2(16, 1), duration: 1)
            }
            
            Global.soundManager.playSound(name: "Explode")
            
            return CountdownTimer(countDownTime: 1.0)
        }
        
        let dieState = PlayerState.DieState {
            
            node.isPaused = true
            node.isHidden = true
            
            scene.playerDeath()
            
            return CountdownTimer(countDownTime: 0.4)
        }
        
        return [resetState, playState, explodeState, dieState]
    }
}
