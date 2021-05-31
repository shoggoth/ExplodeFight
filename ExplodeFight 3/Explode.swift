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
            
            particleSystem.run(.sequence([.wait(forDuration: duration), SKAction(named: "ZoomFadeOut")!, .customAction(withDuration: 0) { node, _ in spawner.kill(node: node) }]))
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
    
    func scaleExplode(node: SKSpriteNode, toScale: vector_float2, withSplits: vector_float2, duration: TimeInterval) {
        
        node.shader = shader
        
        node.setValue(SKAttributeValue(vectorFloat2: withSplits), forAttribute: splitsAttributeName)
        
        let customAction = SKAction.customAction(withDuration: duration) { node, time in
            
            let t = Float(time / CGFloat(duration))
            let x = t * (toScale.x - 1.0) + 1.0
            let y = t * (toScale.y - 1.0) + 1.0
            
            (node as? SKSpriteNode)?.setValue(SKAttributeValue(vectorFloat2: vector_float2(x, y)), forAttribute: explodeAttributeName)
        }
        
        node.run(.group([customAction, .scaleX(by: CGFloat(toScale.x), y: CGFloat(toScale.y), duration: duration)]), withKey: "Explode_PixelShatter")
    }
    
    func explode(node: SKSpriteNode, toScale: vector_float2, withSplits: vector_float2, duration: TimeInterval) {
        
        let warpGeometryGridNoWarp = SKWarpGeometryGrid(columns: 1, rows: 1)
        let sourcePositions: [SIMD2<Float>] = [
            SIMD2<Float>(0, 0),  SIMD2<Float>(1, 0),
            SIMD2<Float>(0, 1),  SIMD2<Float>(1, 1)
        ]
        
        node.shader = shader
        node.warpGeometry = warpGeometryGridNoWarp
        
        node.setValue(SKAttributeValue(vectorFloat2: withSplits), forAttribute: splitsAttributeName)
        
        let customAction = SKAction.customAction(withDuration: duration) { node, time in
            
            let t = Float(time / CGFloat(duration))
            let x = t * (toScale.x - 1.0) + 1.0
            let y = t * (toScale.y - 1.0) + 1.0
            
            (node as? SKSpriteNode)?.setValue(SKAttributeValue(vectorFloat2: vector_float2(x, y)), forAttribute: explodeAttributeName)
        }
        
        let xo = toScale.x * 0.5
        let destinationPositions: [SIMD2<Float>] = [
            SIMD2<Float>(-xo, 0),  SIMD2<Float>(1 + xo, 0),
            SIMD2<Float>(-xo, 1),  SIMD2<Float>(1 + xo, 1)
        ]
        let warpGeometryGrid = SKWarpGeometryGrid(columns: 1, rows: 1, sourcePositions: sourcePositions, destinationPositions: destinationPositions)
        
        node.warpGeometry = warpGeometryGridNoWarp
        node.run(.group([customAction, .warp(to: warpGeometryGrid, duration: 2.0)!]), withKey: "Explode_PixelShatter")
    }
    
    func bulgeExplode(node: SKSpriteNode, toScale: vector_float2, withSplits: vector_float2, duration: TimeInterval) {
        
        let bulgeOffset = Float(0.1)
        let warpGeometryGridNoWarp = SKWarpGeometryGrid(columns: 4, rows: 1)
        let sourcePositions: [SIMD2<Float>] = [
            SIMD2<Float>(0, 0), SIMD2<Float>(0.5 - bulgeOffset, 0), SIMD2<Float>(0.5, 0), SIMD2<Float>(0.5 + bulgeOffset, 0),  SIMD2<Float>(1, 0),
            SIMD2<Float>(0, 1), SIMD2<Float>(0.5 - bulgeOffset, 1), SIMD2<Float>(0.5, 1), SIMD2<Float>(0.5 + bulgeOffset, 1),  SIMD2<Float>(1, 1)
        ]
        
        node.shader = shader
        node.warpGeometry = warpGeometryGridNoWarp
        
        node.setValue(SKAttributeValue(vectorFloat2: withSplits), forAttribute: splitsAttributeName)
        
        let customAction = SKAction.customAction(withDuration: duration) { node, time in
            
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
        node.run(.group([customAction, .warp(to: warpGeometryGrid, duration: 2.0)!]), withKey: "Explode_PixelShatter")
    }
}
