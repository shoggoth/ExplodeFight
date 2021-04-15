//
//  PlayerEntity.swift
//  EF3
//
//  Created by Richard Henry on 27/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit

class MobEntity: GKEntity, ContactNotifiable {

    private var health = 1.0
    
    init(withNode node: SKNode) {
        
        super.init()
        
        node.zRotation = CGFloat(Float.random(in: 0.0 ... Float.pi * 2.0))

        // Entity setup
        addComponent(GKSKNodeComponent(node: node))
        
        let agent = GKAgent2D()
        agent.maxSpeed = 600
        agent.maxAcceleration = 20
        agent.radius = 20
        agent.mass = Float(node.physicsBody?.mass ?? 1)
        
        agent.behavior = GKBehavior(goal: GKGoal(toWander: Float.random(in: -1.0 ... 1.0) * agent.maxSpeed), weight: 10.0)
        agent.delegate = spriteComponent
        addComponent(agent)
    }
    
    required init?(coder: NSCoder) { fatalError() }

    override func update(deltaTime delta: TimeInterval) {
        
        super.update(deltaTime: delta)

        if health < 0.0 {
            
            component(ofType: MobComponent.self)?.stateMachine.enter(ExplodeState.self)
        }
    }
    
    func contactWithEntityDidBegin(_ entity: GKEntity){
        
        health = health - 0.7
    }
    
    func contactWithEntityDidEnd(_ entity: GKEntity){
        
    }
}

protocol ContactNotifiable {

    func contactWithEntityDidBegin(_ entity: GKEntity)
    
    func contactWithEntityDidEnd(_ entity: GKEntity)
}
