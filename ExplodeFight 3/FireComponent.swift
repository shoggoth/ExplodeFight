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
    
    private var fireTicker = PeriodicTimer(tickInterval: 0.3)
    private let weapon = PhysicsWeapon(bullet: DebugBullet())
    
    override func didAddToEntity() {
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        guard let sourceNode = entity?.spriteComponent?.node else { return }
        
        fireTicker = fireTicker.tick(deltaTime: seconds) { weapon.fire(from: sourceNode) }
    }
    
    override class var supportsSecureCoding: Bool { return true }
}

class DebugBullet: SKShapeNode {
    
    override init() {
        
        super.init()
        
        path = CGPath(ellipseIn: CGRect(origin: CGPoint.zero, size: CGSize(width: 10, height: 10)), transform: nil)
        lineWidth = 2.5
        strokeColor = .blue
        
        physicsBody = SKPhysicsBody(circleOfRadius: 5)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    deinit { print("deinit") }
}
