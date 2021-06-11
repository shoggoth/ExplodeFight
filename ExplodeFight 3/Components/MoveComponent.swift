//
//  MoveComponent.swift
//  EF3
//
//  Created by Richard Henry on 28/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit

class MoveComponent : GKAgent2D {

    init(maxSpeed: Float, maxAcceleration: Float, radius: Float, mass: Float) {
        
        super.init()

        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        self.mass = mass
        
        behavior = GKBehavior(goal: GKGoal(toWander: Float.random(in: -1.0 ... 1.0) * maxSpeed), weight: 100)

        delegate = entity?.spriteComponent
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
