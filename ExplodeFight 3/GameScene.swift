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

struct ExplodeShader {
    
    let explodeAttributeName = "a_explodeAmount"
    let explodeShader: SKShader
    
    init(shaderName: String) {
        
        explodeShader = SKShader(fileNamed: "explode.fsh")
        explodeShader.attributes = [SKAttribute(name: explodeAttributeName, type: .float)]
    }
    
    func explode(node: SKSpriteNode, duration: TimeInterval) {
        
        node.shader = explodeShader
        
        let customAction = SKAction.customAction(withDuration: duration) { node, t in
            
            (node as? SKSpriteNode)?.setValue(SKAttributeValue(float: Float(t) * 0.125), forAttribute: explodeAttributeName)
        }
        
        //node.run(.repeatForever(.sequence([customAction, customAction.reversed()])))
        node.run(.repeatForever(.group([customAction, SKAction.scaleX(to: 4.0, duration: duration)])))
    }
}

class GameScene: BaseSKScene {
    
    let explodeShader = ExplodeShader(shaderName: "explode.fsh")
    
    override func didMove(to view: SKView) {
        
        if let node = childNode(withName: "pixelShatter_0") as? SKSpriteNode { explodeShader.explode(node: node, duration: 5) }
        if let node = childNode(withName: "pixelShatter_2") as? SKSpriteNode { explodeShader.explode(node: node, duration: 5) }
    }
}
