//
//  PlayerStates.swift
//  EF3
//
//  Created by Richard Henry on 27/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

struct PlayerState {
    
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
}
