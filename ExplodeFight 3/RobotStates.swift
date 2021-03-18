//
//  RobotStates.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 17/12/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

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

class LiveState: GKState {
    
    private var ct: CountdownTimer?
    
    override func didEnter(from previousState: GKState?) {
        
        ct = CountdownTimer(countDownTime: 3.0)
        print("I gonna live forevah!! \(previousState)")
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        ct = ct?.tick(deltaTime: deltaTime) { print("Ecxpired") }
    }
}

class ExplodeState: GKState {
    
}

class DieState: GKState {
    
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

//}
