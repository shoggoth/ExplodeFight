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
    
    private let trackBehaviour: GKBehavior
    private let moveBehaviour: GKBehavior
    private let stopBehaviour = GKBehavior(goal: GKGoal(toReachTargetSpeed: 0), weight: 10.0)

    private var moveVector: CGVector = .zero
    private var fireVector: CGVector = .zero
    
    init(joystick: TouchJoystick) {
        
        self.joystick = joystick
        self.trackBehaviour = GKBehavior(goal: GKGoal(toSeekAgent: playerControlAgent), weight: 100.0)
        self.moveBehaviour = GKBehavior(goal: GKGoal(toReachTargetSpeed: 2000), weight: 100.0)

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
        
        moveUpdate()
        
        super.update(deltaTime: seconds)
    }
    
    override class var supportsSecureCoding: Bool { return true }
    
    // MARK: Updates
    
    private func moveUpdate() {
    
        guard let entity = entity else { return }
        
        if let agent = entity.agent {
            
            if moveVector.lengthSquared() == 0 {
                
                agent.behavior = stopBehaviour
            
            } else {
                
                entity.spriteComponent?.node.zRotation = moveVector.angle

                let trackVector = agent.position + moveVector.simd
                playerControlAgent.position = trackVector
                agent.behavior = trackBehaviour
            }
        }
    }
}
