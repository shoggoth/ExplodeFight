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

    override func update(deltaTime seconds: TimeInterval) {
        
        super.update(deltaTime: seconds)
    }
    
    override class var supportsSecureCoding: Bool { return true }
}
