//
//  PlayerEntity.swift
//  EF3
//
//  Created by Richard Henry on 27/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit

class PlayerEntity: GKEntity {
 
    init(withNode node: SKNode) {
        
        super.init()

        // Entity setup
        addComponent(GKSKNodeComponent(node: node))
        
        let agent = GKAgent2D()
        agent.maxSpeed = 600
        agent.maxAcceleration = 20
        agent.radius = 20
        agent.mass = Float(node.physicsBody?.mass ?? 1)
        
        agent.delegate = spriteComponent
        addComponent(agent)
    }

    required init?(coder: NSCoder) { fatalError() }
}
