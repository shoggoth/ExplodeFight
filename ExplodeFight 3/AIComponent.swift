//
//  AIComponent.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 17/12/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit

class AIComponent: GKComponent {
    
    // MARK: Properties
    
    let stateMachine: GKStateMachine
    
    // MARK: Initializers
    
    init(states: [GKState]) {
        
        stateMachine = GKStateMachine(states: states)
        if let firstState = states.first { stateMachine.enter(type(of: firstState)) }
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: GKComponent Life Cycle

    override func update(deltaTime seconds: TimeInterval) {
        
        super.update(deltaTime: seconds)

        stateMachine.update(deltaTime: seconds)
    }
}
