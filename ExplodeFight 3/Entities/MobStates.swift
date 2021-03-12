//
//  MobStates.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 17/12/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit

//extension MobEntity {

class MobState: GKState {
    
    // MARK: Properties
    
    var elapsedTime: TimeInterval = 0.0

    unowned var entity: MobEntity
    
    // MARK: Initializers
    
    required init(entity: MobEntity) {
        
        self.entity = entity
    }
}

class WanderState: MobState {
    
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

class PhysicsState: MobState {

    override func didEnter(from previousState: GKState?) {
        
        super.didEnter(from: previousState)
        
        entity.spriteComponent?.node.physicsBody?.affectedByGravity = true
    }
}

class FollowState: GKState {
    
}

class ReturnState: GKState {
    
}

class DebugState: GKState {
    
    private var name: String
    
    // MARK: Initializers
    
    required init(name: String) {
        
        self.name = name
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        super.update(deltaTime: seconds)
        
        print("Debuggin' \(name)")
    }
}

//}
