//
//  Explode.swift
//  EF3
//
//  Created by Richard Henry on 06/04/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons

struct ParticleExploder {
    
    private let spawner: Spawner
    
    init(fileName: String) {
        
        let emitter = SKEmitterNode(fileNamed: fileName)!
        
        spawner = Spawner(node: emitter)
        emitter.removeFromParent()
    }
    
    func explode(node: SKSpriteNode, duration: TimeInterval) {
        
        if let particleSystem = spawner.spawn() {
            
            node.addChild(particleSystem)
            
            particleSystem.run(.sequence([.wait(forDuration: duration), SKAction(named: "ZoomFadeOut")!, .run { spawner.kill(node: node) }]))
        }
    }
}

//MARK: -

struct ExplodeShader {
    
    let splitsAttributeName = "a_numberOfSplits"
    let explodeAttributeName = "a_explodeAmount"
    let shader: SKShader
    
    init(shaderName: String) {
        
        shader = SKShader(fileNamed: shaderName)
        shader.attributes = [SKAttribute(name: splitsAttributeName, type: .vectorFloat2),SKAttribute(name: explodeAttributeName, type: .vectorFloat2)]
    }
    
    func explode(node: SKSpriteNode, toScale: vector_float2, withSplits: vector_float2, duration: TimeInterval, bulgeOffset: Float = 0) {

        let rot = node.zRotation
        node.zRotation = 0

        if let texture = node.scene?.view?.texture(from: node) {
            
            let rttNode = SKSpriteNode(texture: texture)
            rttNode.position = node.position
            rttNode.zRotation = rot
            
            node.parent?.addChild(rttNode)
            node.removeFromParent()
            
            if bulgeOffset != 0 {
                bulgeExplode(node: rttNode, toScale: toScale, withSplits: withSplits, duration: duration, bulgeOffset: bulgeOffset)
            } else {
                scaleExplode(node: rttNode, toScale: toScale, withSplits: withSplits, duration: duration)
            }
        }
    }

    private func scaleExplode(node: SKSpriteNode, toScale: vector_float2, withSplits: vector_float2, duration: TimeInterval) {
        
        node.shader = shader
        
        node.setValue(SKAttributeValue(vectorFloat2: withSplits), forAttribute: splitsAttributeName)
        
        let shaderAction = SKAction.customAction(withDuration: duration) { node, time in
            
            let t = Float(time / CGFloat(duration))
            let x = t * (toScale.x - 1.0) + 1.0
            let y = t * (toScale.y - 1.0) + 1.0
            
            (node as? SKSpriteNode)?.setValue(SKAttributeValue(vectorFloat2: vector_float2(x, y)), forAttribute: explodeAttributeName)
        }
        
        node.run(.sequence([.group([shaderAction, .scaleX(by: CGFloat(toScale.x), y: CGFloat(toScale.y), duration: duration)]), .removeFromParent()]), withKey: "Explode_PixelShatter")
    }
    
    private func bulgeExplode(node: SKSpriteNode, toScale: vector_float2, withSplits: vector_float2, duration: TimeInterval, bulgeOffset: Float) {
        
        let warpGeometryGridNoWarp = SKWarpGeometryGrid(columns: 4, rows: 1)
        let sourcePositions: [SIMD2<Float>] = [
            SIMD2<Float>(0, 0), SIMD2<Float>(0.5 - bulgeOffset, 0), SIMD2<Float>(0.5, 0), SIMD2<Float>(0.5 + bulgeOffset, 0),  SIMD2<Float>(1, 0),
            SIMD2<Float>(0, 1), SIMD2<Float>(0.5 - bulgeOffset, 1), SIMD2<Float>(0.5, 1), SIMD2<Float>(0.5 + bulgeOffset, 1),  SIMD2<Float>(1, 1)
        ]
        
        node.shader = shader
        node.warpGeometry = warpGeometryGridNoWarp
        
        node.setValue(SKAttributeValue(vectorFloat2: withSplits), forAttribute: splitsAttributeName)
        
        let shaderAction = SKAction.customAction(withDuration: duration) { node, time in
            
            let t = Float(time / CGFloat(duration))
            let x = t * (toScale.x - 1.0) + 1.0
            let y = t * (toScale.y - 1.0) + 1.0
            
            (node as? SKSpriteNode)?.setValue(SKAttributeValue(vectorFloat2: vector_float2(x, y)), forAttribute: explodeAttributeName)
        }
        
        let bo = bulgeOffset * toScale.x * 2
        let xo = toScale.x * 0.5
        let destinationPositions: [SIMD2<Float>] = [
            SIMD2<Float>(-xo, 0), SIMD2<Float>((0.5 - bo), 0), SIMD2<Float>(0.5, 0 - toScale.y), SIMD2<Float>((0.5 + bo), 0),  SIMD2<Float>(1 + xo, 0),
            SIMD2<Float>(-xo, 1), SIMD2<Float>((0.5 - bo), 1), SIMD2<Float>(0.5, 1 + toScale.y), SIMD2<Float>((0.5 + bo), 1),  SIMD2<Float>(1 + xo, 1)
        ]
        let warpGeometryGrid = SKWarpGeometryGrid(columns: 4, rows: 1, sourcePositions: sourcePositions, destinationPositions: destinationPositions)
        
        node.warpGeometry = warpGeometryGridNoWarp
        node.run(.sequence([.group([shaderAction, .warp(to: warpGeometryGrid, duration: 2.0)!]), .removeFromParent()]), withKey: "Explode_PixelShatter")
    }
}

// MARK -

extension LinearTexCharSet {
    
    func scoreFlyup(string: String, spacing: Int, parentNode: SKNode) {
        
        let rootNode = makeNodeString(string: string, spacing: spacing)

        rootNode.position = parentNode.position + CGVector(dx: 0, dy: 32)
        rootNode.run(.sequence([.wait(forDuration: 0.1), SKAction(named: "ScoreFlyUp")!, .removeFromParent()]))

        parentNode.scene?.addChild(rootNode)
    }
}

