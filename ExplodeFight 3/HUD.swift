//
//  HUD.swift
//  EF3
//
//  Created by Richard Henry on 16/07/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit

struct HUD {
    
    let scoreLabel: SKLabelNode
    let menLabel: SKLabelNode

    init(scene: GameScene) {
        
        // Setup HUD
        scoreLabel = (scene.childNode(withName: "Camera/Score") as! SKLabelNode)
        menLabel = (scene.childNode(withName: "Camera/Men") as! SKLabelNode)
        menLabel.text = "MEN: \(Defaults.initialNumberofMen)"
    }
    
    func displayScore(score: Int64) {
        
        scoreLabel.text = "SCORE: \(score)"
    }
    
    func displayMen(men: Int) {
        
        menLabel.text = "MEN: \(men)"
    }
}
