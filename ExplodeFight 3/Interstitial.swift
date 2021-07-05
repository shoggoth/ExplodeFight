//
//  Interstitial.swift
//  EF3
//
//  Created by Richard Henry on 01/06/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit

struct Interstitial {

    private let root: SKNode
    private let showAction: SKAction = .sequence([.unhide(), .run { print("unhidden") }, .wait(forDuration: 2.3), SKAction(named: "ZoomFadeOut")!, .hide()])
    
    init(scene: GameScene) {
        
        root = SKReferenceNode(fileNamed: "Interstitial")
        
        ["GetReady", "GameOver", "Bonus"].forEach { name in
            
            root.childNode(withName: "//\(name)")?.reset() { node in
                
                node.isHidden = true
                node.position = .zero
            }
        }
        
        scene.addChild(root)
    }
    
    func flashupNode(named: String, action: SKAction? = nil) {
        
        root.childNode(withName: "//\(named)")?.reset() { node in node.run(action ?? showAction) }
    }
}
