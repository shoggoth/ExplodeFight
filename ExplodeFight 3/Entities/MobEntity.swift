//
//  PlayerEntity.swift
//  EF3
//
//  Created by Richard Henry on 27/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit

class MobEntity: GKEntity, ContactNotifiable {
    
    var moveComponent: MoveComponent? { component(ofType: MoveComponent.self) }

    private var health = 1.0
    
    init(withNode node: SKNode) {
        
        super.init()
        
        node.zRotation = CGFloat(Float.random(in: 0.0 ... Float.pi * 2.0))

        // Entity setup
        node.entity = self
        addComponent(GKSKNodeComponent(node: node))
        addComponent(MoveComponent(maxSpeed: 600, maxAcceleration: 20, radius: 20, mass: Float(node.physicsBody?.mass ?? 1)))
    }
    
    required init?(coder: NSCoder) { fatalError() }

    override func update(deltaTime delta: TimeInterval) {
        
        super.update(deltaTime: delta)

        if health < 0.0 { print("I am deaded XD") }
    }
    
    func contactWithEntityDidBegin(_ entity: GKEntity){
        
        health = health - 0.7
        
        print("Halp I \(self) was hitted!")
    }
    
    func contactWithEntityDidEnd(_ entity: GKEntity){
        
        print("Halp I was unhitted!")
    }
}

protocol ContactNotifiable {

    func contactWithEntityDidBegin(_ entity: GKEntity)
    
    func contactWithEntityDidEnd(_ entity: GKEntity)
}
