//
//  RobotStates.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 17/12/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

class LiveState: GKState {
    
    private var countdownTimer: CountdownTimer?
    
    override func didEnter(from previousState: GKState?) {
        
        countdownTimer = CountdownTimer(countDownTime: 1.0)
        
        if previousState == nil { print("I gonna live forevah!!") } else { print("I live agaain!! \(String(describing: previousState))") }
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        countdownTimer = countdownTimer?.tick(deltaTime: deltaTime) { stateMachine?.enter(ExplodeState.self) }
    }
}

class ExplodeState: GKState {
    
    private var countdownTimer: CountdownTimer?
    
    override func didEnter(from previousState: GKState?) {
        
        countdownTimer = CountdownTimer(countDownTime: 2.0)
        print("Am gonna EXPOLDE!! \(String(describing: previousState))")
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        countdownTimer = countdownTimer?.tick(deltaTime: deltaTime) { stateMachine?.enter(DieState.self) }
    }
}

class DieState: GKState {
    
    private var dieFunc: (() -> Void)?
    
    private var countdownTimer: CountdownTimer?
    
    init(completion: (() -> Void)?) {
        
    dieFunc = completion
    }
    
    override func didEnter(from previousState: GKState?) {
        
        countdownTimer = CountdownTimer(countDownTime: 3.0)
        
        print("Ugh! Lad! He ghot mi!! \(String(describing: previousState))")
        dieFunc?()
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        countdownTimer = countdownTimer?.tick(deltaTime: deltaTime) { stateMachine?.enter(LiveState.self) }
    }
}

class DebugState: GKState {
    
    private var name: String
    
    // MARK: Initializers
    
    required init(name: String) {
        
        self.name = name
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        print("Debuggin' \(name)")
    }
}

/*extension RobotEntity {

//class RobotState: GKState {
//
//    // MARK: Properties
//
//    var elapsedTime: TimeInterval = 0.0
//
//    unowned var entity: RobotEntity
//
//    // MARK: Initializers
//
//    required init(entity: RobotEntity) {
//
//        self.entity = entity
//    }
//}

class WanderState: GKState {
    
    override func update(deltaTime seconds: TimeInterval) {
        
        super.update(deltaTime: seconds)
        
        elapsedTime += seconds

        if elapsedTime >= 3 {
        
            let rand = Int.random(in: 0...2)
            
            print("Call me wanderer... \(rand)")
            //stateMachine?.enter(DebugState.self)
            stateMachine?.enter(PhysicsState.self)
        }
    }

    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        
        super.didEnter(from: previousState)
        
        elapsedTime = 0.0
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        switch stateClass {
        
        case is WanderState.Type:
            elapsedTime = 0.0
            return false
            
        case is FollowState.Type, is ReturnState.Type, is PhysicsState.Type:
            return true
            
        case is DebugState.Type:
            return true
            
        default:
            return false
        }
    }
}

class PhysicsState: GKState {

    override func didEnter(from previousState: GKState?) {
        
        super.didEnter(from: previousState)
        
        //entity.spriteComponent?.node.physicsBody?.affectedByGravity = true
    }
}*/

