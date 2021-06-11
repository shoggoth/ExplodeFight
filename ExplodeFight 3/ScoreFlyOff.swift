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
        
        guard let parentNode = scene?.childNode(withName: "ShipSprite"), let scene = scene else { return }

        let charsTexture = SKTexture(imageNamed: "5x5Charset")
        let charWidth = 1.0 / 44
        let textureDict = Dictionary(uniqueKeysWithValues: " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,'?!/-".enumerated().map { (index: Int, key: Character) -> (Character, SKTexture) in
            
            let tex = SKTexture(rect: CGRect(x: Double(index) * charWidth, y: 0, width: charWidth, height: 1), in: charsTexture)
            tex.filteringMode = .nearest
            
            return (key, tex)
        })

        let node = SKSpriteNode(texture: textureDict["?"])
        node.position = parentNode.position + CGVector(dx: 0, dy: 32)
        scene.addChild(node)
        
        node.run(.sequence([.wait(forDuration: 1.0), SKAction(named: "FlyUp")!, .removeFromParent()]))
    }
}
