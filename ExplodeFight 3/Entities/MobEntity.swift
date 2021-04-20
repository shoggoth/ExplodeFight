//
//  PlayerEntity.swift
//  EF3
//
//  Created by Richard Henry on 27/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

class MobEntity: GKEntity, ContactNotifiable {

    private var health = 1.0
    
    override func update(deltaTime delta: TimeInterval) {
        
        super.update(deltaTime: delta)

        if health < 0.0 {
            
            component(ofType: MobComponent.self)?.stateMachine.enter(ExplodeState.self)
        }
    }
    
    func contactWithEntityDidBegin(_ entity: GKEntity) {
        
        health = health - 0.7
    }
    
    func contactWithEntityDidEnd(_ entity: GKEntity) {
        
    }
}
