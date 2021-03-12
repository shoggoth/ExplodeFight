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
    
    private let scene: BaseSKScene
    private let spawner: Spawner
    private var spawnTicker: PeriodicTimer
    private var killTicker: PeriodicTimer

    init(scene: BaseSKScene) {
        
        self.scene = scene
        
        // Setup spawner
        spawner = Spawner(scene: scene)
        spawnTicker = PeriodicTimer(tickInterval: 1.0)
        killTicker = PeriodicTimer(tickInterval: 10.0)

        // TODO: Temp
        setup()
    }
    
    func update(delta: TimeInterval) {
        
        spawner.update(delta: delta)
        
        killTicker = killTicker.tick(deltaTime: delta) {
            
            spawner.kill()
        }
        
        spawnTicker = spawnTicker.tick(deltaTime: delta) {
            
            scene.addChild(spawner.spawn(name: "Mob") { node in
                
                node.position = CGPoint.zero
                
                return MobEntity(withNode: node)
            }!)
        }
    }
    
    private func setup() {
        
        // Setup entities
        if let node = scene.childNode(withName: "Player") {
            
            let playerEntity = PlayerEntity(withNode: node)
            //playerEntity.addComponent(PlayerControlComponent(joystick: joystick))

            scene.entities.append(playerEntity)
        }
        
        if let node = scene.childNode(withName: "Mob") { scene.entities.append(MobEntity(withNode: node)) }
        
        (1...10).forEach { _ in
            
            if let bar = spawner.spawn(name: "Mob") {
                
                scene.addChild(bar)
                scene.entities.append(MobEntity(withNode: bar))
            }
        }
    }
}
