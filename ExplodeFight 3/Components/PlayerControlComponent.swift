//
//  PlayerControlComponent.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 19/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import GameControls

protocol MoveFireVectors {
    
    var moveVector: CGVector { get }
    var fireVector: CGVector { get }
}

class PlayerControlComponent: GKComponent {
    
    private let joystick: TouchJoystick
    private let playerControlAgent = GKAgent2D()
    
    private let trackBehavior: GKBehavior
    private let stopBehaviour = GKBehavior(goal: GKGoal(toReachTargetSpeed: 0), weight: 100)

    private var moveVector: CGVector = .zero
    private var fireVector: CGVector = .zero
    
    init(joystick: TouchJoystick) {
        
        self.joystick = joystick
        self.trackBehavior = GKBehavior(goal: GKGoal(toSeekAgent: playerControlAgent), weight: 100)

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
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        if let agent = entity?.agent {
            
            if moveVector.lengthSquared() == 0 {
                
                agent.behavior = stopBehaviour
            
            } else {
                let trackVector = agent.position + vector_float2(x: Float(moveVector.dx), y: Float(moveVector.dy))
                
                playerControlAgent.position = trackVector
                
                agent.behavior = trackBehavior
            }
        }
        
        super.update(deltaTime: seconds)
    }
    
    override class var supportsSecureCoding: Bool { return true }
}
