//
//  MoveComponent.swift
//  EF3
//
//  Created by Richard Henry on 28/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit

class MoveComponent : GKAgent2D, GKAgentDelegate {

    let rotationSync: Bool = true
    
    init(maxSpeed: Float, maxAcceleration: Float, radius: Float, mass: Float) {
        
        super.init()

        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        self.mass = mass
        
        behavior = GKBehavior(goal: GKGoal(toWander: Float.random(in: -1.0 ... 1.0) * maxSpeed), weight: 100)
        
        delegate = self
    }
    
    required init?(coder: NSCoder) { fatalError() }

    // MARK: Sync
    
    public func agentWillUpdate(_: GKAgent) {
        
        guard let node = entity?.spriteComponent?.node else { return }
        
        let spritePos = node.position
        position = SIMD2<Float>(x: Float(spritePos.x), y: Float(spritePos.y))
        
        guard rotationSync else { return }
        rotation = Float(node.zRotation)
    }
    
    public func agentDidUpdate(_: GKAgent) {
        
        guard let node = entity?.spriteComponent?.node else { return }

        // Update position
        node.position = CGPoint(x: CGFloat(position.x), y: CGFloat(position.y))
        
        // Update rotation
        guard rotationSync else { return }
        
        let rotation: Float
        if velocity.x > 0.0 || velocity.y > 0.0 {
            rotation = atan2(velocity.y, velocity.x)
        } else { rotation = self.rotation }
        
        // Ensure we have got a valid rotation.
        if !rotation.isNaN { node.zRotation = CGFloat(rotation)}
    }
}
