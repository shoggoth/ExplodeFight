//
//  RobotEntity.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 07/12/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons
import GameplayKit

class RobotEntity: GKEntity, GKAgentDelegate {
    
    var rotationSync: Bool = true
    
    init(track: GKAgent2D? = nil) {
        
        super.init()
        
        let agent = GKAgent2D()
        agent.maxSpeed = 500.0
        agent.maxAcceleration = 10.0
        agent.mass = 0.027
        agent.rotation = Float.random(in: 0.0...Float.pi * 2.0)
        
        agent.delegate = self
        if let ta = track {
            agent.behavior = GKBehavior(goal: GKGoal(toSeekAgent: ta), weight: 100)
        } else {
            agent.behavior = GKBehavior(goal: GKGoal(toWander: Float.random(in: -1.0...1.0) * agent.maxSpeed), weight: 100)
        }
        
        addComponent(agent)
    }
    
    deinit {
        print("deinit")
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: GKAgentDelegate
    
    func agentWillUpdate(_ a: GKAgent) {
        
        syncAgentToSprite()
    }
    
    func agentDidUpdate(_: GKAgent) {
        
        syncSpriteToAgent()
    }
    // MARK: Sync
    
    func syncAgentToSprite() {
        
        guard let agent = agent, let node = spriteComponent?.node else { return }
        
        let spritePos = node.position
        agent.position = SIMD2<Float>(x: Float(spritePos.x), y: Float(spritePos.y))
        
        // guard rotationSync else { return }
        // agent.rotation = Float(node.zRotation)
    }
    
    func syncSpriteToAgent() {
        
        guard let agent = agent, let node = spriteComponent?.node else { return }
        
        // Update position
        let agentPos = agent.position
        node.position = CGPoint(x: CGFloat(agentPos.x), y: CGFloat(agentPos.y))
        
        // Update rotation
        guard rotationSync else { return }
        
        let rotation: Float
        if agent.velocity.x > 0.0 || agent.velocity.y > 0.0 {
            rotation = atan2(agent.velocity.y, agent.velocity.x)
        } else { rotation = agent.rotation }
        
        // Ensure we have got a valid rotation.
        if !rotation.isNaN { node.zRotation = CGFloat(rotation)}
    }
}
