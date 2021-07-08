//
//  GatedState.swift
//  Tests
//
//  Created by Richard Henry on 08/07/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import XCTest
import GameplayKit

class GatedStateTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBeginAndEndStates() throws {
        
        let states = [BeginState(), EndState()]
        let stateMachine = GKStateMachine(states: states)

        XCTAssertNil(stateMachine.currentState)
        
        if let firstState = states.first { stateMachine.enter(type(of: firstState)) }
        XCTAssertNotNil(stateMachine.currentState)
        XCTAssertTrue(stateMachine.currentState is BeginState)
        
        stateMachine.enter(EndState.self)
        XCTAssertNotNil(stateMachine.currentState)
        XCTAssertTrue(stateMachine.currentState is EndState)
        
        stateMachine.enter(BeginState.self)
        XCTAssertNotNil(stateMachine.currentState)
        XCTAssertTrue(stateMachine.currentState is EndState)
    }
    
    func testClosureParams() throws {
        
        let begin = BeginState()
        begin.enterFunc = { [unowned begin] prev in if prev == nil { begin.updateAccumulator = -1 }}
        begin.updateFunc = { [unowned begin] dt in
            begin.updateAccumulator += dt
            if begin.updateAccumulator >= 1.0 { begin.stateMachine?.enter(EndState.self) }
        }
        begin.exitFunc = { _ in print("Begin:exit") }
        let end = EndState(enter: { state in print("End:enter \(state)") }, exit: { state in print("End:exit \(state)") }, update: { dt in print("End:update \(dt)") })
        let states = [begin, end]
        let stateMachine = GKStateMachine(states: states)

        XCTAssertNil(stateMachine.currentState)
        
        if let firstState = states.first { stateMachine.enter(type(of: firstState)) }
        XCTAssertNotNil(stateMachine.currentState)
        XCTAssertTrue(stateMachine.currentState is BeginState)
        XCTAssert(begin.updateAccumulator == -1)
        
        stateMachine.update(deltaTime: 0.5)
        XCTAssert(begin.updateAccumulator == -0.5)
        stateMachine.update(deltaTime: 0.5)
        XCTAssert(begin.updateAccumulator == 0)
        stateMachine.update(deltaTime: 0.5)
        XCTAssert(begin.updateAccumulator == 0.5)
        stateMachine.update(deltaTime: 0.5)
        XCTAssert(begin.updateAccumulator == 1.0)
        
        XCTAssertTrue(stateMachine.currentState is EndState)
        
        stateMachine.update(deltaTime: 0.5)
        stateMachine.update(deltaTime: 0.75)
        stateMachine.update(deltaTime: 0.25)
        XCTAssert(begin.updateAccumulator == 1.0)
    }
    
    func testParams() throws {
        
        let begin = BeginState(
            enter: { prev in
                print("Begin:enter \(prev)")
            },
            exit: { next in
                print("Begin:exit \(next)")
            },
            update: { dt in
                print("Begin:update \(dt)")
            })
        
        let end = EndState(enter: { state in print("End:enter \(state)") }, exit: { state in print("End:exit \(state)") }, update: { dt in print("End:update \(dt)") })
        let states = [begin, end]
        let stateMachine = GKStateMachine(states: states)

        XCTAssertNil(stateMachine.currentState)
        
        if let firstState = states.first { stateMachine.enter(type(of: firstState)) }
        XCTAssertNotNil(stateMachine.currentState)
        XCTAssertTrue(stateMachine.currentState is BeginState)
        
        stateMachine.update(deltaTime: 1)

        stateMachine.enter(EndState.self)
        XCTAssertNotNil(stateMachine.currentState)
        XCTAssertTrue(stateMachine.currentState is EndState)
        
        stateMachine.enter(BeginState.self)
        XCTAssertNotNil(stateMachine.currentState)
        XCTAssertTrue(stateMachine.currentState is EndState)
    }

    class GatedState: GKState {
        
        var updateFunc: ((TimeInterval) -> ())?
        var enterFunc: ((GKState?) -> ())?
        var exitFunc: ((GKState) -> ())?

        public init(enter: ((GKState?) -> ())? = nil, exit: ((GKState) -> ())? = nil, update: ((TimeInterval) -> ())? = nil) {
            
            updateFunc = update
            enterFunc = enter
            exitFunc = exit
        }
        
        deinit { print("deinit \(self)") }
        
        open override func didEnter(from previousState: GKState?) { enterFunc?(previousState) }
        
        open override func willExit(to nextState: GKState) { exitFunc?(nextState) }
        
        open override func update(deltaTime: TimeInterval) {
            
            super.update(deltaTime: deltaTime)
            
            updateFunc?(deltaTime)
        }
    }

    class BeginState: GatedState {
        
        var updateAccumulator: TimeInterval = 0
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is EndState.Type }
    }
    
    class EndState: GatedState {
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { false }
    }
}
