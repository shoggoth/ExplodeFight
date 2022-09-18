//
//  Weapon.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 12/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons

protocol Weapon {
    
    var emitNode: SKNode? { get set }
    func fire(direction: CGVector)
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

        //bullet.physicsBody?.velocity = fireVel
        //bullet.run(.move(by: fireVel, duration: 2.0))
         
        scene.addChild(bullet)

        bullet.fire(vector: fireVel) { b in b.reset { _ in self.magazine?.insert(b, at: 0) }}
    }
}

// MARK: -

class LaserCannon: Weapon {
    
    var emitNode: SKNode?

    func fire(direction: CGVector) {
        print("Firing ma laser")
    }
}
