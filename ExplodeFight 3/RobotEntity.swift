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
    
    var agent: GKAgent2D? { component(ofType: GKAgent2D.self) }
    
    override init() {
        
        super.init()
        
        let agent = GKAgent2D()
        agent.delegate = self
        agent.behavior = GKBehavior()
        
        addComponent(agent)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: GKAgentDelegate
    
    func agentWillUpdate(_: GKAgent) {
        
        syncAgentToSprite()
        
        /*
            `GKAgent`s do not operate in the SpriteKit physics world,
            and are not affected by SpriteKit physics collisions.
            Because of this, the agent's position and rotation in the scene
            may have values that are not valid in the SpriteKit physics simulation.
            For example, the agent may have moved into a position that is not allowed
            by interactions between the `TaskBot`'s physics body and the level's scenery.
            To counter this, set the agent's position and rotation to match
            the `TaskBot` position and orientation before the agent calculates
            its steering physics update.
        */
        
        //updateAgentPositionToMatchNodePosition()
        //updateAgentRotationToMatchTaskBotOrientation()
        
    }
    
    func agentDidUpdate(_: GKAgent) {
        
        syncSpriteToAgent()
    }
    
    // MARK: Sync
    
    func syncAgentToSprite() {
        
        guard let agent = agent, let pos = spriteComponent?.node.position else { return }
        
        agent.position = SIMD2<Float>(x: Float(pos.x), y: Float(pos.y))
    }
    
    func syncSpriteToAgent() {
        
        guard let pos = agent?.position, let node = spriteComponent?.node else { return }
        
        node.position = CGPoint(x: CGFloat(pos.x), y: CGFloat(pos.y))
    }
}
