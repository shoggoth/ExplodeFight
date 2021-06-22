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

    private let explodeShader = ExplodeShader(shaderName: "explode.fsh")
    
    init(scene: GameScene) {
        
        self.scene = scene
        
        // Global setup
        AppDelegate.soundManager.playNode = scene
        
        // Setup spawner
        mobSpawner = SceneSpawner(scene: SKScene(fileNamed: "Mobs")!)
    }
    
    func update(deltaTime: TimeInterval) {

        mobSpawner.update(deltaTime: deltaTime)
    }
    
    func spawnMob(name: String) {
        
        let key = "ExplodeKey"
        
        let _ = mobSpawner.spawn(name: name) { node in
            
            node.reset() { r in
                
                r.position = CGPoint.zero
                r.isPaused = false
            }
            
            let directionIndicator = node.childNode(withName: "DirectionIndicator")
            
            let mobEntity = MobEntity(withNode: node)
            
            mobEntity.addComponent(MobComponent(states: [
                                                    LiveState(),
                                                    ExplodeState {
                                                        AppDelegate.soundManager.playSound(name: "Explode")
                                                        directionIndicator?.run(SKAction.moveTo(x: 32, duration: 0.2), withKey: key)
                                                        self.explodeShader.explode(node: node as! SKSpriteNode, toScale: vector_float2(7, 1), withSplits: vector_float2(16, 1), duration: 1)
                                                    },
                                                    DieState {
                                                        directionIndicator?.removeAction(forKey: key)
                                                        (node as? SKSpriteNode)?.color = .yellow
                                                        self.mobSpawner.spawner(named: name)?.kill(node: node, recycle: true)
                                                    }]))
            
            mobEntity.addComponent(DebugComponent())
            
            self.spawnRoot.addChild(node)
            
            return mobEntity
        }
    }
    
    func explodeAllMobs() {
        
        mobSpawner.iterateEntities { entity in entity.component(ofType: MobComponent.self)?.stateMachine.enter(ExplodeState.self) }
    }
    
    func killAllMobs() {
        
        mobSpawner.kill(recycle: false)
    }
}
