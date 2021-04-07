//
//  MobComponent.swift
//  EF3
//
//  Created by Richard Henry on 19/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

class MobComponent: GKComponent {
    
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
}

// MARK: - Lifecycle states -

class LiveState: CountdownState {
    
    init(completion: (() -> CountdownTimer?)? = nil) { super.init(enter: completion, exit: { stateMachine in stateMachine?.enter(ExplodeState.self) }) }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is DieState.Type || stateClass is ExplodeState.Type }
}

class ExplodeState: CountdownState {
    
    init(completion: (() -> CountdownTimer?)? = nil) { super.init(enter: completion, exit: { stateMachine in stateMachine?.enter(DieState.self) }) }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is DieState.Type }
}

class DieState: GKState {
    
    private var dieFunc: (() -> Void)?
    
    init(completion: (() -> Void)? = nil) { dieFunc = completion }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool { false }
    
    override func didEnter(from previousState: GKState?) { dieFunc?() }
}

// MARK: -

class CountdownState: GKState {
    
    private var enterFunc: (() -> CountdownTimer?)?
    private var exitFunc: ((GKStateMachine?) -> Void)?
    private var countdownTimer: CountdownTimer?
    
    init(enter: (() -> CountdownTimer?)? = nil, exit: ((GKStateMachine?) -> Void)? = nil) {
        
        enterFunc = enter
        exitFunc  = exit
    }
    
    override func didEnter(from previousState: GKState?) {
        
        countdownTimer = enterFunc?()
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        countdownTimer = countdownTimer?.tick(deltaTime: deltaTime) { exitFunc?(stateMachine) }
    }
}
