//
//  ScoreFlyOff.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 23/11/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons

extension GameScene {
    
    func scoreflyoff() {
        
        guard let parentNode = scene?.childNode(withName: "ShipSprite") else { return }

        let charsTexture = SKTexture(imageNamed: "5x5Charset")
        let charWidth = 1.0 / 44
        let alphabet = " ABCD"
        let textureDict = Dictionary(uniqueKeysWithValues: alphabet.enumerated().map { ($1, SKTexture(rect: CGRect(x: Double($0) * charWidth, y: 0, width: charWidth, height: 1), in: charsTexture)) })
        let _ = textureDict.map { $1.filteringMode = .nearest}
        
        let node = SKSpriteNode(texture: textureDict["C"])
        node.position = CGPoint(x: 0, y: 32)
        parentNode.addChild(node)
        
        node.run(.sequence([.wait(forDuration: 1.0), SKAction(named: "FlyUp")!]))
    }
}
