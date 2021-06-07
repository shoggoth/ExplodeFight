//
//  States.swift
//  Tests
//
//  Created by Richard Henry on 05/06/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import XCTest
import GameplayKit

class States: XCTestCase {

    func testInitialState() throws {

        let states = [BeginState()]
        let stateMachine = GKStateMachine(states: states)

        XCTAssertNil(stateMachine.currentState)
        
        if let firstState = states.first { stateMachine.enter(type(of: firstState)) }

        XCTAssertNotNil(stateMachine.currentState)
        XCTAssertTrue(stateMachine.currentState is BeginState)
        
        // Can enter the state even though it isn't in the state machine
        XCTAssertTrue(stateMachine.canEnterState(RunLevelState.self))
    }

    func testValidTransitions() throws {
        
        let states = [BeginState(), RunLevelState()]
        let stateMachine = GKStateMachine(states: states)
        
        if let firstState = states.first { stateMachine.enter(type(of: firstState)) }

        XCTAssertTrue(stateMachine.canEnterState(RunLevelState.self))
        
        stateMachine.enter(RunLevelState.self)
        XCTAssertTrue(stateMachine.currentState is RunLevelState)
    }

    func testInvalidTransitions() throws {
        
        let states = [BeginState()]
        let stateMachine = GKStateMachine(states: states)
    }

    class GameState: GKState {
        
        let updateFunc: ((TimeInterval) -> ())?
        let enterFunc: ((GKState?) -> ())?
        let exitFunc: ((GKState?) -> ())?

        init(enterFunc: ((GKState?) -> ())? = nil, exitFunc: ((GKState?) -> ())? = nil, updateFunc: ((TimeInterval) -> ())? = nil) {
            
            self.updateFunc = updateFunc
            self.enterFunc = enterFunc
            self.exitFunc = exitFunc
            
            super.init()
        }
        
        override func didEnter(from previousState: GKState?) {
            
            enterFunc?(previousState)
            
            super.didEnter(from: previousState)
        }
        
        override func update(deltaTime seconds: TimeInterval) {
            
            updateFunc?(seconds)
            
            super.update(deltaTime: seconds)
        }
        
        override func willExit(to nextState: GKState) {
            
            exitFunc?(nextState)
            
            super.willExit(to: nextState)
        }
    }
    
    class BeginState: GameState {
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
            stateClass is RunLevelState.Type || stateClass is EndState.Type
        }
    }
    
    class RunLevelState: GKState {
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
            stateClass is EndState.Type
        }
    }
    
    class EndState: GKState {
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
            stateClass is BeginState.Type
        }
    }
}
