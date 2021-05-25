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
                                                    LiveState(warpNode: node as! SKSpriteNode),
                                                    ExplodeState {
                                                        AppDelegate.soundManager.playSound(name: "Explode")
                                                        if let node = node.childNode(withName: "Recycled") as? SKSpriteNode {
                                                            node.color = .white
                                                            node.run(SKAction.moveBy(x: 0, y: 8, duration: 0.2))
                                                        }
                                                    },
                                                    DieState {
                                                        if let node = node.childNode(withName: "Recycled") as? SKSpriteNode {
                                                            node.color = .red
                                                            node.run(SKAction.moveBy(x: 0, y: -8, duration: 0.2))
                                                        }
                                                        self.mobSpawner.spawner(named: "Mob")?.kill(node: node, recycle: true)
                                                    }]))
            
            mobEntity.addComponent(DebugComponent())
            
            self.spawnRoot.addChild(node)
            
            return mobEntity
        }
    }
}
