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
    
    let splitsAttributeName = "a_numberOfSplits"
    let explodeAttributeName = "a_explodeAmount"
    let explodeShader: SKShader
    
    init(shaderName: String) {
        
        explodeShader = SKShader(fileNamed: "explode.fsh")
        explodeShader.attributes = [SKAttribute(name: splitsAttributeName, type: .vectorFloat2),SKAttribute(name: explodeAttributeName, type: .vectorFloat2)]
    }
    
    func explode(node: SKSpriteNode, duration: TimeInterval) {
        
        node.shader = explodeShader
        
        node.setValue(SKAttributeValue(vectorFloat2: vector_float2(2, 1)), forAttribute: splitsAttributeName)

        let customAction = SKAction.customAction(withDuration: duration) { node, t in
            
            let x = Float(t * 0.5) + 1.0
            print(x)
            (node as? SKSpriteNode)?.setValue(SKAttributeValue(vectorFloat2: vector_float2(x, 1.0)), forAttribute: explodeAttributeName)
        }
        
        //node.run(.repeatForever(.sequence([customAction, customAction.reversed()])))
        node.run(.repeatForever(.group([customAction, SKAction.scaleX(to: 2.0, duration: duration)])))
    }
}

class GameScene: BaseSKScene {
    
    let explodeShader = ExplodeShader(shaderName: "explode.fsh")
    
    override func didMove(to view: SKView) {
        
        if let node = childNode(withName: "pixelShatter_X") as? SKSpriteNode { explodeShader.explode(node: node, duration: 2) }
        if let node = childNode(withName: "pixelShatter_Y") as? SKSpriteNode { explodeShader.explode(node: node, duration: 2) }
    }
}
