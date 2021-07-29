//
//  PlayerControlComponent.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 19/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import GameControls

class PlayerControlComponent: GKComponent {
    
    private let joystick: TwinStick

    private let moveBehaviour = GKBehavior(goal: GKGoal(toReachTargetSpeed: 2000), weight: 100.0)
    private let stopBehaviour = GKBehavior(goal: GKGoal(toReachTargetSpeed: 0), weight: 10.0)
    
    /*
    init(joystick: TouchJoystick) {
        
        self.joystick = joystick

        super.init()
        
        // TODO: Load from the configuration or defaults.
        let moveWindowFunc = TouchJoystick.WindowFunction(clippingType: .square(40), deadZoneR2: 4)
        let fireWindowFunc = TouchJoystick.WindowFunction(clippingType: .square(40))

        joystick.joyFunctions = [
            { touch in
                
                moveWindowFunc.handleTouch(touch: touch)
                self.moveVector = moveWindowFunc.windowVector
            },
            { touch in
                
                fireWindowFunc.handleTouch(touch: touch)
                self.fireVector = fireWindowFunc.windowVector.snapped(to: .pi * 0.25)
            }
        ]
    }*/
    
    init(joystick: TwinStick) {
        
        self.joystick = joystick
        
        super.init()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        moveUpdate()
        fireUpdate()
        
        super.update(deltaTime: seconds)
    }
    
    override class var supportsSecureCoding: Bool { return true }
    
    // MARK: Updates
    
    private func moveUpdate() {
    
        guard let entity = entity else { return }
        
        if let agent = entity.agent {
            
            if joystick.moveVector.lengthSquared() == 0 {
                
                agent.behavior = stopBehaviour
            
            } else {
                
                entity.spriteComponent?.node.zRotation = joystick.moveVector.angle
                agent.behavior = moveBehaviour
            }
        }
    }
    
    private func fireUpdate() {

        entity?.component(ofType: FireComponent.self)?.fireVector = joystick.fireVector.normalized()
    }
}
