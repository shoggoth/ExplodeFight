//
//  Bonus.swift
//  EF3
//
//  Created by Richard Henry on 08/06/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit

struct Bonus {
    
    let imageName: String
    let spacing: Int
    let interval: TimeInterval
    
    func countUpNodeBonus(root: SKNode, count: Int) {
        
        var index = 1
        let key = "countUpNodeBonusKey"
        let wait = SKAction.wait(forDuration: interval)
        let block = SKAction.run {
            
            let tomNode = SKSpriteNode(imageNamed: imageName)
            tomNode.position = CGPoint(x: spacing * index, y: 0)
            tomNode.setScale(2)
            root.addChild(tomNode)
            tomNode.run(.playSoundFileNamed("Fire2.caf", waitForCompletion: false))
            
            index += 1
        }
        
        root.removeAction(forKey: key)
        root.removeAllChildren()
        root.run(.repeat(.sequence([block, wait]), count: count), withKey: key)
    }
}
