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
    @GKInspectable var fireRate = 1.0

    var fireVector = CGVector.zero
    
    private var fireTicker: PeriodicTimer!
    private var weapon: Weapon? = nil
    
    override func didAddToEntity() {
        
        switch weaponType {
        case 1:
            weapon = {
                let w = NodeCannon()
                w.emitNode = entity?.spriteComponent?.node
                w.magazine = [1, 1, 1].map { rad in  RoundBullet(radius: rad) }

                return w
            }()
        case 2:
            weapon = {
                let w = NodeCannon()
                w.emitNode = entity?.spriteComponent?.node
                w.magazine = [1, 2, 3, 4, 5, 4, 3, 2, 1].map { rad in  RoundBullet(radius: rad) }

                return w
            }()
        case 3:
            weapon = {
                let w = NodeCannon()
                w.emitNode = entity?.spriteComponent?.node
                w.magazine = [10, 10, 10].map { rad in  RoundBullet(radius: rad) }

                return w
            }()
        case 4:
            weapon = {
                let w = NodeCannon()
                w.emitNode = entity?.spriteComponent?.node
                w.magazine = [2, 16, 32].map { rad in  RoundBullet(radius: rad) }

                return w
            }()
        case 5:
            weapon = {
                let w = LaserCannon()
                w.emitNode = entity?.spriteComponent?.node

                return w
            }()
        default: break
        }
        
        fireTicker = PeriodicTimer(tickInterval: fireRate)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        guard let weapon = weapon, fireVector.lengthSquared() > 0 else { return }
        
        fireTicker = fireTicker.tick(deltaTime: seconds) { weapon.fire(direction: fireVector) }
    }
    
    override class var supportsSecureCoding: Bool { return true }
}

