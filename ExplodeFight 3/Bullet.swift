//
//  Bullet.swift
//  ExplodeFight iOS
//
//  Created by Richard Henry on 30/07/2021.
//

import SpriteKit
import SpriteKitAddons

protocol NodeBullet: SKNode {
    
    func fire(vector: CGVector, completion: ((NodeBullet) -> Void)?)
}

// MARK: - Bullets -

class RoundBullet: SKShapeNode, NodeBullet {
    
    override init() {
        
        super.init()
        
        name = "Round Bullet"
        setup(radius: 4)
    }
    
    init(radius: CGFloat) {
        
        super.init()
        
        setup(radius: radius)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func setup(radius: CGFloat) {
        
        let diameter = radius * 2
        
        path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -radius, y: -radius), size: CGSize(width: diameter / 2, height: diameter)), transform: nil)
        lineWidth = radius * 0.25
        //glowWidth = radius * 0.125
        strokeColor = .white
        
        physicsBody = {
            let body = SKPhysicsBody(circleOfRadius: radius)
            body.categoryBitMask = 0b0100
            
            return body
        }()
    }
    
    func fire(vector: CGVector, completion: ((NodeBullet) -> Void)? = nil) {
        
        physicsBody?.velocity = vector
        //bullet.run(.move(by: vector, duration: 2.0))

        let repeatingKey = "rotateRepeatKey"
        
        // TODO: Use an action for the movement here and allow the fire method to be switched between that and one propelled by physics velocity.
        let s: SKAction = .playSoundFileNamed("Laser.caf", waitForCompletion: false)
        let t: SKAction = .repeatForever(.rotate(byAngle: pi, duration: 1))
        let u: SKAction = .sequence([.wait(forDuration: 0.75), .fadeOut(withDuration: 0.25), .removeFromParent(), .run { self.reset { node in completion?(self); node.removeAction(forKey: repeatingKey) }}])
        
        run(.group([s, u]))
        run(t, withKey: repeatingKey)
    }
}

// MARK: -

class DebugBullet: RoundBullet {
    
    override init() { super.init() }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    deinit { print("deinit") }
}

