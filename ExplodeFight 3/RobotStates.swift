//
//  RobotStates.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 17/12/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit

//extension RobotEntity {

class RobotState: GKState {
    
    // MARK: Properties
    unowned var entity: RobotEntity
    
    // MARK: Initializers
    
    required init(entity: RobotEntity) {
        
        self.entity = entity
    }
}

class WanderState: RobotState {
    
    override func update(deltaTime seconds: TimeInterval) {
        
        print("Call me wanderer...")
        
        super.update(deltaTime: seconds)
    }

}

class FollowState: GKState {
    
}

class ReturnState: GKState {
    
}
//}
