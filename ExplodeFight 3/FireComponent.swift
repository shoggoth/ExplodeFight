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
    
    private var fireTicker = PeriodicTimer(tickInterval: 0.3)
    private var weapon : Weapon?
    
    override func didAddToEntity() {
        
        let bullet = SKShapeNode.init(rectOf: CGSize.init(width: 10, height: 10), cornerRadius: 3)
        
        bullet.lineWidth = 2.5
        bullet.strokeColor = SKColor.blue
        
        bullet.run(SKAction.repeatForever(SKAction.rotate(byAngle: pi, duration: 1)))
        bullet.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()]))
        bullet.run(SKAction.playSoundFileNamed("blast.caf", waitForCompletion: false))
        
        weapon = PhysicsWeapon(bullet: bullet)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        guard let sourceNode = entity?.spriteComponent?.node else { return }
        
        fireTicker = fireTicker.tick(deltaTime: seconds) { weapon?.fire(from: sourceNode) }
    }
    
    override class var supportsSecureCoding: Bool { return true }
}
