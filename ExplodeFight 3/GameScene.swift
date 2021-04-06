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
    
    func explode(node: SKSpriteNode, toScale: vector_float2, withSplits: vector_float2, duration: TimeInterval) {
        
        node.shader = explodeShader
        
        node.setValue(SKAttributeValue(vectorFloat2: withSplits), forAttribute: splitsAttributeName)

        let customAction = SKAction.customAction(withDuration: duration) { node, time in
            
            let t = Float(time / CGFloat(duration))
            let x = t * (toScale.x - 1.0) + 1.0
            let y = t * (toScale.y - 1.0) + 1.0

            (node as? SKSpriteNode)?.setValue(SKAttributeValue(vectorFloat2: vector_float2(x, y)), forAttribute: explodeAttributeName)
        }
        
        node.run(.group([customAction, SKAction.scaleX(by: CGFloat(toScale.x), y: CGFloat(toScale.y), duration: duration)]))
    }
}

class GameScene: BaseSKScene {
    
    let explodeShader = ExplodeShader(shaderName: "explode.fsh")
    
    override func didMove(to view: SKView) {
        
        if let node = childNode(withName: "pixelShatter_X") as? SKSpriteNode { explodeShader.explode(node: node, toScale: vector_float2(2, 1), withSplits: vector_float2(2, 1), duration: 3.1765) }
        if let node = childNode(withName: "pixelShatter_Y") as? SKSpriteNode { explodeShader.explode(node: node, toScale: vector_float2(1, 2), withSplits: vector_float2(1, 2), duration: 7.5432) }
        if let node = childNode(withName: "pixelShatter_XY") as? SKSpriteNode { explodeShader.explode(node: node, toScale: vector_float2(3, 3), withSplits: vector_float2(7, 5), duration: 2.564) }
    }
}
