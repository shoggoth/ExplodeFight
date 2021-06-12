//
//  ScoreFlyOff.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 23/11/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons

public struct LinearTexCharSet {

    let textureDict: [Character : SKTexture]
    
    init(texName: String, alphabet: String) {
        
        let charTexture = SKTexture(imageNamed: texName)
        let charWidth = 1.0 / CGFloat(alphabet.count)
        textureDict = Dictionary(uniqueKeysWithValues: alphabet.enumerated().map { (index: Int, key: Character) -> (Character, SKTexture) in
            
            let tex = SKTexture(rect: CGRect(x: CGFloat(index) * charWidth, y: 0, width: charWidth, height: 1), in: charTexture)
            tex.filteringMode = .nearest
            
            return (key, tex)
        })
    }
    
    func makeNodeString(string: String, spacing: Int) -> SKNode {
        
        let rootNode = SKNode()

        string.enumerated().forEach { index, char in
            
            let node = SKSpriteNode(texture: textureDict[char])
            node.position = CGPoint(x: CGFloat(spacing * index), y: 0)
            rootNode.addChild(node)
        }

        return rootNode
    }
}

extension LinearTexCharSet {
    
    func flyup(string: String, spacing: Int, parentNode: SKNode) {
        
        let rootNode = makeNodeString(string: string, spacing: spacing)

        rootNode.position = parentNode.position + CGVector(dx: 0, dy: 32)
        rootNode.run(.sequence([.wait(forDuration: 1.0), SKAction(named: "FlyUp")!]))

        parentNode.scene?.addChild(rootNode)
    }
}

extension GameScene {
    
    func scoreflyoff() {
        
        guard let parentNode = scene?.childNode(withName: "ShipSprite") else { return }
        let node = LinearTexCharSet(texName: "5x5Charset", alphabet : " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,'?!/-").makeNodeString(string: "WELL, WHAT CAN THIS BE?", spacing: 5)
        
        parentNode.addChild(node)
    }
    
    func scoreflyoff1() {
        
        guard let parentNode = scene?.childNode(withName: "ShipSprite") else { return }
        
        LinearTexCharSet(texName: "5x5Charset", alphabet : " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,'?!/-").flyup(string: "HELLO", spacing: 5, parentNode: parentNode)
    }
    
    func scoreflyoff2() {
        
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
