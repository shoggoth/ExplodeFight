//
//  MobStates.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 17/12/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

struct MobState {
    
    class ResetState: LambdaState {
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is DieState.Type || stateClass is ExplodeState.Type }
    }
    
    class ExplodeState: CountdownState {
        
        init(completion: (() -> CountdownTimer?)? = nil) { super.init(enter: completion, expire: { stateMachine in stateMachine?.enter(DieState.self) }) }
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is DieState.Type }
    }
    
    class DieState: LambdaState {
                
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { false }
    }
}
