//
//  PlayerEntity.swift
//  EF3
//
//  Created by Richard Henry on 27/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit

class PlayerEntity: GKEntity {
    
    var moveComponent: MoveComponent? { component(ofType: MoveComponent.self) }

    init(withNode node: SKNode) {
        
        super.init()
        
        node.zRotation = CGFloat(Float.random(in: 0.0 ... Float.pi * 2.0))

        // Entity setup
        node.entity = self
        addComponent(GKSKNodeComponent(node: node))
        addComponent(MoveComponent(maxSpeed: 300, maxAcceleration: 10, radius: 20, mass: Float(node.physicsBody?.mass ?? 1)))
    }

    required init?(coder: NSCoder) { fatalError() }
}
