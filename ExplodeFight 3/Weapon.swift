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
    
    func fire(from node: SKNode)
}

class PhysicsWeapon: Weapon {
    
    private var bulletNode : SKNode

    init(bullet: SKNode) {
        
        self.bulletNode = bullet
    }
    
    func fire(from node: SKNode) {
        
        if let bullet = self.bulletNode.copy() as? SKNode {
            
            let v = CGVector(angle: halfPi) * 32

            bullet.position = node.position + v
            bullet.physicsBody = {
                
                let body = SKPhysicsBody(circleOfRadius: 5)
                
                body.affectedByGravity = true
                body.velocity = v * 25
                
                return body
            }()

            node.addChild(bullet)
        }
    }
}
