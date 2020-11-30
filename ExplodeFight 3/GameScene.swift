//
//  GameScene.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 23/11/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons
import GameplayKit
import GameControls

class GameScene: BaseSKScene, ButtonSKSpriteNodeResponder {
    
    private let joystick = TouchJoystick()
    
    override func didMove(to view: SKView) {
        
        joystick.joyFunctions = [
            { touch in self.printToLabel("Joy touch 1") },
            { touch in self.printToLabel("Joy touch 2") }
        ]
    }
    
    override func update(delta: TimeInterval) {
        
        super.update(delta: delta)
    }

    // MARK: Temp
    
    private func printToLabel(_ s: String) {
        
        if let label = self.childNode(withName: "//coordInfoLabel") as? SKLabelNode {
            
            label.text = s
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        joystick.touchesBegan(touches, with: event)
        //for (i, t) in touches.enumerated() { printToLabel("Begin touch \(i) at \(t.location(in: self))") }
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        joystick.touchesMoved(touches, with: event)
        //for (i, t) in touches.enumerated() { printToLabel("Moved touch \(i) at \(t.location(in: self))") }
        //for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        joystick.touchesEnded(touches, with: event)
        //for (i, t) in touches.enumerated() { printToLabel("Ended touch \(i) at \(t.location(in: self))") }
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        joystick.touchesCancelled(touches, with: event)
        //for (i, t) in touches.enumerated() { printToLabel("Cancelled touch \(i) at \(t.location(in: self))") }
        //for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
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

class TouchJoystick {
    
    typealias JoystickTouchFunction = (_ touch: UITouch) -> Void
    
    public var joyFunctions: [TouchFunction] = []

    private var joyTouches: [UITouch?] = []

    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touches.forEach { t in
            
            // Use the first slot in the array where we find a nil value. If there are no nil slots, append to the array
            // as long as there aren't more touches than there are functions to be called on that touch.
            if let i = joyTouches.firstIndex(where: { $0 == nil }) {
                
                joyTouches[i] = t
                joyFunctions[i](t)
                
            } else {
                
                if joyTouches.count < joyFunctions.count {
                    
                    joyFunctions[joyTouches.count](t)
                    joyTouches.append(t)
                }
            }
        }
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touches.forEach { t in

            // Find the touch in the touch array and call the appropriate function (at the same index).
            if let i = joyTouches.firstIndex(where: { $0 == t }) { joyFunctions[i](t) }
        }
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touches.forEach { t in

            // Set the appropriate slot in the array to nil so that it can be re-used.
            if let i = joyTouches.firstIndex(where: { $0 == t }) {
                
                joyFunctions[i](t)
                joyTouches[i] = nil
            }
        }
    }
    
    func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Just do the same operation as if the touch had ended.
        touchesEnded(touches, with: event)
    }
}

/*
//  TouchController.swift
//  GameControls
//
//  Created by Richard Henry on 20/03/2017.
//  Copyright © 2017 Dogstar Industries. All rights reserved.
//

import UIKit

public typealias TouchFunction = (_ touch: UITouch) -> Void

public class TouchControllerView : UIView {
    
    @IBInspectable public var viewName: String = "Unnamed"
    
    public var joyFunctions: [TouchFunction] = []
    
    private var joyTouches: [UITouch?] = []
    
    required public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        #if DEBUG
            if let grArray = self.gestureRecognizers, grArray.count > 0 {
                
                print("TouchStickController warning: view \(self) already has \(grArray.count) gesture recognisers.")
                
                for (i, gr) in grArray.enumerated() { print("Recogniser \(i): \(gr)") }
            }
        #endif
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        #if DEBUG
            if let grArray = self.gestureRecognizers, grArray.count > 0 {
                
                print("TouchStickController warning: view \(self) already has \(grArray.count) gesture recognisers.")
                
                for (i, gr) in grArray.enumerated() { print("Recogniser \(i): \(gr)") }
            }
        #endif
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            // Use the first slot in the array where we find a nil value. If there are no nil slots, append to the array
            // as long as there aren't more touches than there are functions to be called on that touch.
            if let i = joyTouches.firstIndex(where: { $0 == nil }) {
                
                joyTouches[i] = t
                joyFunctions[i](t)
                
            } else {
                
                if joyTouches.count < joyFunctions.count {
                    
                    joyFunctions[joyTouches.count](t)
                    joyTouches.append(t)
                }
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            // Find the touch in the touch array and call the appropriate function (at the same index).
            if let i = joyTouches.firstIndex(where: { $0 == t }) { joyFunctions[i](t) }
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            // Set the appropriate slot in the array to nil so that it can be re-used.
            if let i = joyTouches.firstIndex(where: { $0 == t }) {
                
                joyFunctions[i](t)
                joyTouches[i] = nil
            }
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Just do the same operation as if the touch had ended.
        touchesEnded(touches, with: event)
    }
}

public class WindowFunction {
    
    public var windowVector: CGPoint = CGPoint()
    public var deadZoneRadiusSquared: CGFloat = 0.0
    
    private let size:  CGSize
    private var origin: CGPoint = CGPoint()
    
    public init(windowSize size: CGSize, deadZoneR2 dzr2: CGFloat = 0.0) {
        
        self.size = size
        self.deadZoneRadiusSquared = dzr2 * dzr2
    }
    
    public func handleTouch(touch: UITouch) {
        
        let touchPoint = touch.location(in: touch.view)
        
        switch touch.phase {
            
        case .began:
            origin = touchPoint
            windowVector = CGPoint()
            
        case .moved:
            var vector = CGPoint(x:  touchPoint.x - origin.x, y: -(touchPoint.y - origin.y))
            
            // Clip that vector
            if vector.x > size.width { origin.x += vector.x - size.width; vector.x = size.width }
            else if vector.x < -size.width { origin.x += vector.x + size.width; vector.x = -size.width }
            
            if vector.y > size.height { origin.y -= vector.y - size.height; vector.y = size.height }
            else if vector.y < -size.height { origin.y -= vector.y + size.height; vector.y = -size.height }
            
            let vectorLengthSquared = vector.x * vector.x + vector.y * vector.y
            
            windowVector = vectorLengthSquared > deadZoneRadiusSquared ? vector : CGPoint()
            
        case .ended, .cancelled:
            windowVector = CGPoint()

        default:break
        }
    }
}
*/
