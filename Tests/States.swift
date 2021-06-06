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

    let states = [BeginState()]
    var stateMachine: GKStateMachine?
    
    override func setUpWithError() throws {
        
        // This method is called before the invocation of each test method in the class.
        stateMachine = GKStateMachine(states: states)
    }

    override func tearDownWithError() throws {
        
        // This method is called after the invocation of each test method in the class.
    }

    private func enterInitialState() {
        
        // Enter initial state
        if let firstState = states.first { stateMachine?.enter(type(of: firstState)) }
    }
    
    func testInitialState() throws {

        XCTAssertNil(stateMachine?.currentState)
        
        enterInitialState()

        XCTAssertNotNil(stateMachine?.currentState)
        XCTAssertTrue(stateMachine?.currentState is BeginState)
    }

    func testValidTransitions() throws {
        
        enterInitialState()

        XCTAssertTrue(stateMachine?.canEnterState(RunLevelState.self) ?? false)
        
        stateMachine?.enter(RunLevelState.self)
        stateMachine?.update(deltaTime: 1)
        XCTAssertTrue(stateMachine?.currentState is RunLevelState)
    }

    func testInvalidTransitions() throws {
        
        enterInitialState()

        XCTAssertTrue(stateMachine?.currentState is BeginState)
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
