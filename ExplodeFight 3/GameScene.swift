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
 
        let texOffsetAttributeName = "a_texOffset"
        let animationAttributeName = "a_animation"
        let texOffsetShader = SKShader(fileNamed: "texOffset.fsh")
        texOffsetShader.attributes = [SKAttribute(name: texOffsetAttributeName, type: .vectorFloat2), SKAttribute(name: animationAttributeName, type: .float)]
        
        let customAction = SKAction.customAction(withDuration: 2.0) { node, t in
            
            if let node = node as? SKSpriteNode {
                
                node.setValue(SKAttributeValue(float: Float(t * 0.5)), forAttribute: animationAttributeName)
            }
        }
        
        [("texOffsetNode", vector_float2(0.0, 0.5)), ("texOffsetNode2", vector_float2(0.5, 0.0))].forEach { name, tc in
            
            if let node = childNode(withName: name) as? SKSpriteNode {
                
                node.shader = texOffsetShader
                node.setValue(SKAttributeValue(vectorFloat2: tc), forAttribute: texOffsetAttributeName)
                node.setValue(SKAttributeValue(float: 0), forAttribute: animationAttributeName)
                
                node.run(.repeatForever(.sequence([
                    .wait(forDuration: 1.0),
                    customAction,
                    customAction.reversed()
                ])))
            }
        }
    }
}

public class DebugComponent: GKComponent {
    
    @GKInspectable var identifier: String = "Anonymous"
    @GKInspectable var dumpTiming: Bool = false

    public override class var supportsSecureCoding: Bool { true }
    
    deinit { print(" \(self.identifier) \(self) deinits") }
    
    // MARK: Update
    
    public override func update(deltaTime seconds: TimeInterval) {
        
        super.update(deltaTime: seconds)
        
        if dumpTiming { print("\(self) update at \(seconds)s") }
    }
    
    public override func didAddToEntity() {
        
        print("Component \(self.identifier) \(self) added to entity \(String(describing: entity))")
        //print("Sprite component \(String(describing: spriteComponent))")
    }
    
    public override func willRemoveFromEntity() {
        
        print("Component \(self) will remove from entity \(String(describing: entity))")
    }
}
