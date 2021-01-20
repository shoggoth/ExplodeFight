//
//  Joystick.swift
//  EF3
//
//  Created by Richard Henry on 20/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons
import GameControls

extension GameScene {
    
    func setupJoystick(_ joystick: TouchJoystick) {
        
        let absoluteFunctions: [TouchJoystick.TouchFunction] = [
            { touch in print("pos 1 = \(touch.location(in: self))") },
            { touch in print("pos 2 = \(touch.location(in: self))") }
        ]
        
        let moveWindowFunc = TouchJoystick.WindowFunction(windowSize: CGSize(width: 40, height: 40), deadZoneR2: 4)
        let fireWindowFunc = TouchJoystick.WindowFunction(windowSize: CGSize(width: 40, height: 40))

        let windowFunctions: [TouchJoystick.TouchFunction] = [
            { touch in
                
                moveWindowFunc.handleTouch(touch: touch)
                print("move stick = \(moveWindowFunc.windowVector)")
            },
            { touch in
                
                fireWindowFunc.handleTouch(touch: touch)
                print("fire stick = \(fireWindowFunc.windowVector)")
            }
        ]
        
        joystick.joyFunctions = absoluteFunctions
        joystick.joyFunctions = windowFunctions
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesBegan(touches, with: event) }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesMoved(touches, with: event) }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesEnded(touches, with: event) }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesCancelled(touches, with: event) }
}
