//
//  Weapon.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 12/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

protocol Weapon {
    
    func fire(direction: CGVector)
}

protocol NodeBullet: SKNode {
    
    func fire(completion: ((NodeBullet) -> Void)?)
}

// MARK: - Weapons -

class NodeCannon: Weapon {
    
    var magazine: [NodeBullet]?
    var emitNode: SKNode?

    func fire(direction: CGVector) {
        
        guard let emitNode = self.emitNode,
              let scene = emitNode.scene,
              let bullet = magazine?.popLast() else { return }
        
        
        let firePos = direction * 64
        let fireVel = direction * 1024
        
        bullet.position = scene.convert(CGPoint.zero, from: emitNode) + firePos

        bullet.physicsBody?.velocity = fireVel
        //bullet.run(.move(by: fireVel, duration: 2.0))
         
        scene.addChild(bullet)

        bullet.fire { b in b.reset { _ in self.magazine?.insert(b, at: 0) }}
    }
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
        
        path = CGPath(ellipseIn: CGRect(origin: CGPoint(x: -radius, y: -radius), size: CGSize(width: diameter, height: diameter)), transform: nil)
        lineWidth = radius * 0.25
        //glowWidth = radius * 0.125
        strokeColor = .white
        
        physicsBody = {
            let body = SKPhysicsBody(circleOfRadius: radius)
            body.categoryBitMask = 0b0100
            
            return body
        }()
    }
    
    func fire(completion: ((NodeBullet) -> Void)? = nil) {

        // TODO: Use an action for the movement here and allow the fire method to be switched between that and one propelled by physics velocity.
        let s = SKAction.playSoundFileNamed("Laser.caf", waitForCompletion: false)
        let t = SKAction.repeatForever(.rotate(byAngle: pi, duration: 1))
        let u = SKAction.sequence([.wait(forDuration: 0.75), .fadeOut(withDuration: 0.25), .removeFromParent(), .run { self.reset { _ in completion?(self); self.removeAllActions() }}])
        run(.group([s, t, u]))
    }
}

// MARK: -

class DebugBullet: RoundBullet {
    
    override init() { super.init() }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    deinit { print("deinit") }
}

