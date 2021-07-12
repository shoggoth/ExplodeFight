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
    private let showAction: SKAction = .sequence([.unhide(), .wait(forDuration: 2.3), SKAction(named: "ZoomFadeOut")!, .hide()])
    
    init(scene: GameScene) {
        
        root = SKReferenceNode(fileNamed: "Interstitial")
        
        hideNodes(names: ["GetReady", "GameOver", "Bonus"])
        
        root.childNode(withName: "//Bonus/Tomato")?.isHidden = true

        scene.addChild(root)
    }
    
    func hideNodes(names: [String]) {
        
        names.forEach { name in
            
            root.childNode(withName: "//\(name)")?.reset() { node in
                
                node.isHidden = true
                node.position = .zero
            }
        }
    }
    
    func setLevelName(name: String) {
        
        if let nameRoot = root.childNode(withName: "//GetReady/Root") as? SKLabelNode { nameRoot.text = name }
    }
    
    func flashupNode(named: String, action: SKAction? = nil) {
        
        root.childNode(withName: "//\(named)")?.reset() { node in node.run(action ?? showAction) }
    }
    
    func countBonus() {
        
        if let bonusRoot = root.childNode(withName: "//Bonus/Root/SuccessLabel/Count") { Bonus(imageName: "Pickup14", spacing: 23, interval: 0.23).countUpNodeBonus(root: bonusRoot, count: 10) }
        if let bonusRoot = root.childNode(withName: "//Bonus/Root/MenLabel/Count") { Bonus(imageName: "Pickup6", spacing: 34, interval: 0.75).countUpNodeBonus(root: bonusRoot, count: 3) }
    }
}
