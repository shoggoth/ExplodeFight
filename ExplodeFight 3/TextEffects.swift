//
//  TextEffects.swift
//  EF3
//
//  Created by Richard Henry on 25/05/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit

func makeRevealer(text: [(Int, String)], rt: Double, ft: Double) -> SKNode {

    let size = CGFloat(24)
    
    let rootNode = SKNode()
    var timeBase = 0.0
    rootNode.run(.sequence([.wait(forDuration: rt * Double(text.count)), .fadeOut(withDuration: ft)]))
    
    text.forEach { i, s in
        
        let label = SKLabelNode(text: s)
        label.alpha = 1.0
        label.fontName = "Robotron"
        label.fontSize = size
        label.position = CGPoint(x: 0, y: CGFloat(i) * -size)
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .baseline
        
        let revealer = SKSpriteNode(color: .black, size: CGSize(width: 1024, height: size))
        revealer.zPosition = 1
        revealer.position = CGPoint(x: 0, y: 0.4 * size)
        revealer.run(.sequence([.wait(forDuration: timeBase * rt), .move(by: CGVector(dx: 1024, dy: 0), duration: rt)]))
        
        label.addChild(revealer)
        rootNode.addChild(label)
        
        timeBase += 1.0
    }
    
    return rootNode
}
