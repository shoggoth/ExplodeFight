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
    
    public override class var supportsSecureCoding: Bool { return true }
}

// MARK: - Lifecycle states -

class LiveState: GKState {
    
    private var countdownTimer: CountdownTimer?
    
    override func didEnter(from previousState: GKState?) {
        
        countdownTimer = CountdownTimer(countDownTime: 30.0)
        
        //if previousState == nil { print("I gonna live forevah!!") } else { print("I live agaain!! \(String(describing: previousState))") }
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        countdownTimer = countdownTimer?.tick(deltaTime: deltaTime) { stateMachine?.enter(ExplodeState.self) }
    }
}

class ExplodeState: GKState {
    
    private var explodeFunc: (() -> Void)?
    private var countdownTimer: CountdownTimer?
    
    init(completion: (() -> Void)? = nil) { explodeFunc = completion }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        return stateClass is DieState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        
        countdownTimer = CountdownTimer(countDownTime: 2.0)
        
        explodeFunc?()
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        countdownTimer = countdownTimer?.tick(deltaTime: deltaTime) { stateMachine?.enter(DieState.self) }
    }
}

class DieState: GKState {
    
    private var dieFunc: (() -> Void)?
    private var countdownTimer: CountdownTimer?
    
    init(completion: (() -> Void)? = nil) { dieFunc = completion }
    
    override func didEnter(from previousState: GKState?) {
        
        countdownTimer = CountdownTimer(countDownTime: 3.0)
        
        dieFunc?()
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        countdownTimer = countdownTimer?.tick(deltaTime: deltaTime) { stateMachine?.enter(LiveState.self) }
    }
}
