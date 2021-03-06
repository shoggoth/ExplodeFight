//
//  DebugComponent.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 07/12/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

public class DebugComponent: GKComponent {
    
    @GKInspectable var identifier: String = UUID().uuidString
    @GKInspectable var dumpTiming: Bool = false
    
    deinit { print(" \(self.identifier) \(self) deinits") }
    
    // MARK: Update
    
    public override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        if dumpTiming { print("\(self) update at \(deltaTime)s") }
    }
    
    public override func didAddToEntity() {
        
        print("DebugComponent '\(self.identifier)' (\(self)) added to entity: \(String(describing: entity))")
        print("Sprite component on add: \(String(describing: entity?.spriteComponent))")
    }
    
    public override func willRemoveFromEntity() {
        
        print("Component \(self) will remove from entity \(String(describing: entity))")
        print("Sprite component on remove: \(String(describing: entity?.spriteComponent))")
    }
    
    public override class var supportsSecureCoding: Bool { return true }
}
