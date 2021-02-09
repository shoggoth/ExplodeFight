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
    
    @GKInspectable var weaponType = 1
    
    private var fireTicker = PeriodicTimer(tickInterval: 1.0)
    private let weapon = PhysicsWeapon(bullet: DebugBullet())
    
    override func didAddToEntity() {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        guard let sourceNode = entity?.spriteComponent?.node else { return }
        
        fireTicker = fireTicker.tick(deltaTime: seconds) { weapon.fire(from: sourceNode) }
    }
    
    override class var supportsSecureCoding: Bool { return true }
}

