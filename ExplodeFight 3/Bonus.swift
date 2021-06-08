//
//  Bonus.swift
//  EF3
//
//  Created by Richard Henry on 08/06/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit

struct Bonus {
    
    func countUpNodeBonus(root: SKNode) {
        
        var index = 1
        let spacing = 23
        let key = "countUpNodeBonusKey"
        let wait = SKAction.wait(forDuration: 0.23)
        let block = SKAction.run {
            
            let tomNode = SKSpriteNode(imageNamed:"Tomato")
            tomNode.position = CGPoint(x: spacing * index, y: 0)
            tomNode.setScale(2)
            root.addChild(tomNode)
            
            index += 1
        }
        
        root.removeAction(forKey: key)
        root.removeAllChildren()
        root.run(.repeat(.sequence([block, wait]), count: 10), withKey: key)
    }
}
