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
    
    var name: String { get }
    func fire(from node: SKNode)
}

protocol Bullet {
    
    func fire(completion: ((SKNode) -> Void)?)
    func reset()
}

class NodeCannon<T: SKNode & Bullet>: Weapon {
    
    let name = "Node Cannon"

    private var magazine: [T] = []

    func fire(from node: SKNode) {
        
        guard magazine.count > 0 else { return }
        
        if let foo = magazine.popLast() {
            
            foo.physicsBody = nil
            foo.fire { _ in }
        }
    }
}

class PhysicsWeapon: Weapon {
    
    let name = "Physics Weapon"
    
    private var bulletNode: SKNode
    private var recycle: [SKNode] = []

    init(bullet: SKNode) {
        
        self.bulletNode = bullet
        
        bullet.removeFromParent()
    }
    
    func fire(from node: SKNode) {
 
        if let bullet = recycle.popLast() ?? self.bulletNode.copy() as? SKNode {
            
            let v = CGVector(angle: node.zRotation + (pi * 0.5))
            
            bullet.position = CGPoint(x: 0, y: 32)
            //bullet.physicsBody = nil
            bullet.physicsBody?.velocity = v * 1024
            
            node.addChild(bullet)
            
            (bullet as? Bullet)?.fire { node in self.recycle.append(node) }
        }
    }
}

// MARK: -

class RoundBullet: SKShapeNode, Bullet {
    
    override init() {
        
        super.init()
        
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
    
    func fire(completion: ((SKNode) -> Void)? = nil) {

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

