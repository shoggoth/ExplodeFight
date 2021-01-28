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
    
    let playerControlAgent = GKAgent2D()
    
    var joystick: TouchJoystick? { didSet {
        
        guard let joystick = joystick else { return }
        
        // TODO: Load from the configuration or defaults.
        let moveWindowFunc = TouchJoystick.WindowFunction(windowSize: CGSize(width: 40, height: 40), deadZoneR2: 4)
        let fireWindowFunc = TouchJoystick.WindowFunction(windowSize: CGSize(width: 40, height: 40))

        joystick.joyFunctions = [
            { touch in
                
                moveWindowFunc.handleTouch(touch: touch)
                print("move stick = \(moveWindowFunc.windowVector)")
            },
            { touch in
                
                fireWindowFunc.handleTouch(touch: touch)
                print("fire stick = \(fireWindowFunc.windowVector)")
            }
        ]
    }}

    override func didAddToEntity() {
        
        print("PlayerControlComponent added to entity with agent: \(entity?.agent)")
        //if let ta = track {
        //    agent.behavior = GKBehavior(goal: GKGoal(toSeekAgent: ta), weight: 100)
        //} else {
        //    agent.behavior = GKBehavior(goal: GKGoal(toWander: Float.random(in: -1.0 ... 1.0) * agent.maxSpeed), weight: 100)
        //}
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        super.update(deltaTime: seconds)
    }
    
    override class var supportsSecureCoding: Bool { return true }
}
