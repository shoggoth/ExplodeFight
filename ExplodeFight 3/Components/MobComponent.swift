//
//  MobComponent.swift
//  EF3
//
//  Created by Richard Henry on 19/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

class MobComponent: GKComponent, NodeContact {
    
    let stateMachine: GKStateMachine
    
    init(states: [GKState]) {
        
        stateMachine = GKStateMachine(states: states)
        if let firstState = states.first { stateMachine.enter(type(of: firstState)) }
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)

        stateMachine.update(deltaTime: deltaTime)
    }
    
    // MARK: Contact handling
    
    func contactWithNodeDidBegin(_ node: SKNode) {
        
        //print("MC Contact begins: \(self) with \(node)")
        stateMachine.enter(MobState.ExplodeState.self)
    }
    
    func contactWithNodeDidEnd(_ node: SKNode) {
        
        //print("MC Contact ends: \(self) with \(node)")
    }
}

// MARK: -

protocol NodeContact {

    func contactWithNodeDidBegin(_ node: SKNode)
    
    func contactWithNodeDidEnd(_ node: SKNode)
}

extension SKNode: NodeContact {
    
    func contactWithNodeDidBegin(_ node: SKNode) {
        
        entity?.component(ofType: MobComponent.self)?.contactWithNodeDidBegin(node)
    }
    
    func contactWithNodeDidEnd(_ node: SKNode) {
        
        entity?.component(ofType: MobComponent.self)?.contactWithNodeDidEnd(node)
    }
}

