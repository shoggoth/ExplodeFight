//
//  Revealer.swift
//  EF3
//
//  Created by Richard Henry on 25/05/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit

func makeRevealer(text: [String]) -> SKNode {

    // Temp
    let revealTime = 2.3
    let fadeTime = 0.23

    let size = CGFloat(24)
    
    let rootNode = SKNode()
    rootNode.run(SKAction.sequence([SKAction.wait(forDuration: revealTime * Double(text.count)), SKAction.fadeOut(withDuration: fadeTime)]))
    
    text.enumerated().forEach { i, s in
        
        let label = SKLabelNode(text: s)
        label.alpha = 1.0
        label.fontName = "Robotron"
        label.fontSize = size
        label.position = CGPoint(x: 0, y: CGFloat(i) * -size)
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .baseline
        
        let revealer = SKSpriteNode(color: .red, size: CGSize(width: 1024, height: size))
        revealer.zPosition = 1
        revealer.position = CGPoint(x: 0, y: 0.4 * size)
        revealer.run(SKAction.sequence([SKAction.wait(forDuration: Double(i) * revealTime), SKAction.move(by: CGVector(dx: 1024, dy: 0), duration: revealTime)]))
        
        label.addChild(revealer)
        rootNode.addChild(label)
    }
    
    return rootNode
}
