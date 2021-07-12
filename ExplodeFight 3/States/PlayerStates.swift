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
    
    class ResetState: CountdownState {
        
        init(completion: (() -> CountdownTimer?)? = nil) { super.init(enter: completion, expire: { stateMachine in stateMachine?.enter(PlayState.self) }) }
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is PlayState.Type }
    }
    
    class PlayState: GKState {
        
        override func didEnter(from previousState: GKState?) {
            
            print("Entered play state")
            
            stateMachine?.enter(ExplodeState.self)
        }
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is DieState.Type || stateClass is ExplodeState.Type }
    }
    
    class ExplodeState: CountdownState {
        
        init(completion: (() -> CountdownTimer?)? = nil) { super.init(enter: completion, expire: { stateMachine in stateMachine?.enter(DieState.self) }) }
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is DieState.Type }
    }
    
    class DieState: CountdownState {
        
        init(completion: (() -> CountdownTimer?)? = nil) { super.init(enter: completion, expire: { stateMachine in stateMachine?.enter(ResetState.self) }) }
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is ResetState.Type }    }
}
