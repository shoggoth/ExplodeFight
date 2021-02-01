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

    private var moveVector: CGVector = .zero
    private var fireVector: CGVector = .zero
    
    init(joystick: TouchJoystick) {
        
        self.joystick = joystick
        
        super.init()
        
        // TODO: Load from the configuration or defaults.
        let moveWindowFunc = TouchJoystick.WindowFunction(windowSize: CGSize(width: 40, height: 40), deadZoneR2: 4)
        let fireWindowFunc = TouchJoystick.WindowFunction(windowSize: CGSize(width: 40, height: 40))
        
        joystick.joyFunctions = [
            { touch in
                
                moveWindowFunc.handleTouch(touch: touch)
                self.moveVector = moveWindowFunc.windowVector
                print("move stick = \(moveWindowFunc.windowVector)")
            },
            { touch in
                
                fireWindowFunc.handleTouch(touch: touch)
                print("fire stick = \(fireWindowFunc.windowVector)")
            }
        ]
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        if let moveComponent = entity?.component(ofType: MoveComponent.self) {
            
            if moveVector.lengthSquared() == 0 {
                
                moveComponent.behavior = GKBehavior(goal: GKGoal(toReachTargetSpeed: 0), weight: 100)
            
            } else {
                let trackVector = moveComponent.position + vector_float2(x: Float(moveVector.dx), y: Float(moveVector.dy))
                
                let ta = GKAgent2D()
                ta.position = trackVector
                
                moveComponent.behavior = GKBehavior(goal: GKGoal(toSeekAgent: ta), weight: 100)
            }
        }
        
        super.update(deltaTime: seconds)
    }
    
    override class var supportsSecureCoding: Bool { return true }
}
