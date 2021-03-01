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
    private var weapon: Weapon? = nil
    
    override func didAddToEntity() {
        
        print("Weapon type = \(weaponType)")
        
        switch weaponType {
        case 1:
            weapon = {
                let w = NodeCannon()
                w.emitNode = entity?.spriteComponent?.node
                
                return w
            }()
        case 2:
            weapon = {
                let w = NodeCannon()
                w.emitNode = entity?.spriteComponent?.node
                w.magazine = [2, 16, 32].map { rad in  RoundBullet(radius: rad) }
                
                return w
            }()
        default: break
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        guard let weapon = weapon, let sourceNode = entity?.spriteComponent?.node else { return }
        
        fireTicker = fireTicker.tick(deltaTime: seconds) { weapon.fire(direction: CGVector(angle: sourceNode.zRotation + (pi * 0.5))) }
    }
    
    override class var supportsSecureCoding: Bool { return true }
}

