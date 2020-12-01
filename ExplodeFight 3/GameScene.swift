//
//  GameScene.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 23/11/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons
import GameplayKit
import GameControls

class GameScene: BaseSKScene {
    
    override func didMove(to view: SKView) {
        
        if let node = childNode(withName: "texOffsetNode") as? SKSpriteNode {
            
            let shader = SKShader(fileNamed: "texOffset.fsh")
            shader.attributes = [SKAttribute(name: "a_texOffset", type: .vectorFloat2)]
            
            node.shader = shader
            
            node.setValue(SKAttributeValue(vectorFloat2: vector_float2(0.0, 0.5)), forAttribute: "a_texOffset")
        }
    }
    
    override func update(delta: TimeInterval) {
        
        super.update(delta: delta)
    }
}

public class DebugComponent: GKComponent {
    
    @GKInspectable var identifier: String = "Anonymous"
    
    public override class var supportsSecureCoding: Bool { true }
    
    deinit { print(" \(self.identifier) \(self) deinits") }
    
    // MARK: Update
    
    public override func update(deltaTime seconds: TimeInterval) {
        
        super.update(deltaTime: seconds)
        
        print("\(self) update at \(seconds)s")
    }
    
    public override func didAddToEntity() {
        
        print("Component \(self.identifier) \(self) added to entity \(String(describing: entity))")
        //print("Sprite component \(String(describing: spriteComponent))")
    }
    
    public override func willRemoveFromEntity() {
        
        print("Component \(self) will remove from entity \(String(describing: entity))")
    }
}
