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
    func fire(from node: SKNode, type: Int)
}

class PhysicsWeapon: Weapon {
    
    let name = "Physics Weapon"
    
    private var bulletNode: SKNode
    private var recycle: [SKNode] = []

    init(bullet: SKNode) {
        
        self.bulletNode = bullet
    }
    
    func fire(from node: SKNode, type: Int) {
 
        if let bullet = recycle.popLast() ?? self.bulletNode.copy() as? SKNode {
            
            let v = CGVector(angle: node.zRotation + (pi * 0.5))
            
            bullet.run(SKAction.playSoundFileNamed("blast.caf", waitForCompletion: false))
            bullet.run(SKAction.repeatForever(SKAction.rotate(byAngle: pi, duration: 1)))
            bullet.run(SKAction.sequence([SKAction.wait(forDuration: 0.75), SKAction.fadeOut(withDuration: 0.25), SKAction.removeFromParent(), SKAction.run {
                
                bullet.removeAllActions()
                bullet.alpha = 1

                self.recycle.append(bullet)
            }]))
            
            bullet.position = CGPoint(x: 0, y: 32)
            bullet.physicsBody?.velocity = v * 1024
            
            node.addChild(bullet)
        }
    }
}
