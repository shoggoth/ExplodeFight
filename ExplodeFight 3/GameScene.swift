//
//  GameScene.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 23/11/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons
import GameControls

class GameScene: BaseSKScene, ButtonSKSpriteNodeResponder {
    
    private let joystick = TouchJoystick()
    
    override func didMove(to view: SKView) {
        
        guard let moveSIndicator = self.childNode(withName: "//joystickBoundsLeft/indicator") else { return }
        guard let fireSIndicator = self.childNode(withName: "//joystickBoundsRight/indicator") else { return }
        guard let moveCIndicator = self.childNode(withName: "//joystickCircLeft/indicator") else { return }
        guard let fireCIndicator = self.childNode(withName: "//joystickCircRight/indicator") else { return }

        let absoluteFunctions: [TouchJoystick.TouchFunction] = [
            { touch in moveSIndicator.position = touch.location(in: self) },
            { touch in fireSIndicator.position = touch.location(in: self) }
        ]
        
        let moveWindowFunc = TouchJoystick.WindowFunction(windowSize: CGSize(width: 80, height: 80), deadZoneR2: 10)
        let fireWindowFunc = TouchJoystick.WindowFunction(windowSize: CGSize(width: 80, height: 80))

        let windowFunctions: [TouchJoystick.TouchFunction] = [
            { touch in
                
                moveWindowFunc.handleTouch(touch: touch)
                moveSIndicator.position = CGPoint(vector: moveWindowFunc.windowVector)
                moveCIndicator.position = CGPoint(vector: moveWindowFunc.windowVector)
            },
            { touch in
                
                fireWindowFunc.handleTouch(touch: touch)
                fireSIndicator.position = CGPoint(vector: fireWindowFunc.windowVector)
            }
        ]

        joystick.joyFunctions = absoluteFunctions
        joystick.joyFunctions = windowFunctions
    }

    // MARK: Temp
    
    private func printToLabel(_ s: String) {
        
        if let label = self.childNode(withName: "//coordInfoLabel") as? SKLabelNode {
            
            label.text = s
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesBegan(touches, with: event) }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesMoved(touches, with: event) }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesEnded(touches, with: event) }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesCancelled(touches, with: event) }
    
    func buttonTriggered(button: ButtonSKSpriteNode) {
        
        if let label = self.childNode(withName: "//buttonInfoLabel") as? SKLabelNode {
            
            label.text = button.name ?? "Unnamed button"
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        if button.name == "selectedButton" {
            
            button.isSelected.toggle()
        }
    }
}
