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
    func reset()
}

// MARK: - Weapons -

class NodeCannon: Weapon {
    
    var magazine: [NodeBullet]?
    var emitNode: SKNode?

    func fire(direction: CGVector) {
        
        guard let emitNode = self.emitNode,
              let scene = emitNode.scene,
              let bullet = magazine?.popLast() else { return }
        
        //bullet.physicsBody = nil
        bullet.physicsBody?.velocity = direction * 1024
        
        let firePos = CGPoint(x: 42, y: 0)
        bullet.position = scene.convert(firePos, from: emitNode)
        
        scene.addChild(bullet)

        bullet.fire { b in
            
            b.reset()
            self.magazine?.insert(b, at: 0)
        }
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
        strokeColor = .blue
        
        // TODO: Need physics for collision?
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
    }
    
    func fire(completion: ((NodeBullet) -> Void)? = nil) {

        // TODO: Use an action for the movement here abd allow the fire method to be switched between that and one propelled by physics velocity.
        //run(SKAction.playSoundFileNamed("blast.caf", waitForCompletion: false))
        run(SKAction.repeatForever(SKAction.rotate(byAngle: pi, duration: 1)))
        run(SKAction.sequence([SKAction.wait(forDuration: 0.75), SKAction.fadeOut(withDuration: 0.25), SKAction.removeFromParent(), SKAction.run { self.reset(); completion?(self) }]))
    }
    
    func reset() {
        
        removeAllActions()
        
        alpha = 1
    }
}

// MARK: -

class DebugBullet: RoundBullet {
    
    override init() { super.init() }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    deinit { print("deinit") }
}

