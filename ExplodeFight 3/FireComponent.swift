//
//  FireComponent.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 08/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

class FireComponent: GKComponent {
    
    private var fireTicker = PeriodicTimer(tickInterval: 0.25)
    private var bulletNode : SKShapeNode?
    
    override func update(deltaTime seconds: TimeInterval) {
        
        fireTicker = fireTicker.tick(deltaTime: seconds) { fire() }
    }
    
    func fire() {
        
        if self.bulletNode == nil {
            
            let bullet = SKShapeNode.init(rectOf: CGSize.init(width: 10, height: 10), cornerRadius: 3)

            bullet.lineWidth = 2.5
            bullet.strokeColor = SKColor.blue

            bullet.run(SKAction.repeatForever(SKAction.rotate(byAngle: pi, duration: 1)))
            bullet.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()]))
            
            self.bulletNode = bullet
        }
        
        if let bullet = self.bulletNode?.copy() as? SKShapeNode, let node = entity?.spriteComponent?.node {
            
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
    
    override class var supportsSecureCoding: Bool { return true }
}
