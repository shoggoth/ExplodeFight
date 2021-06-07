//
//  GameScene.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 23/11/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons
import GameplayKit
import GameControls

class GameScene: BaseSKScene {
    
    private lazy var referenceNode: SKReferenceNode? = { print("foo"); return SKReferenceNode(fileNamed: "Reference") }()

    var retainer: SKNode?
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // Set up user control
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addRef)))
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(clear)))

        // Set up scene physics
        self.physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
    }
    
    @objc func addRef(_ tap: UITapGestureRecognizer) {
        
        if let node = referenceNode {
            
            node.childNode(withName: "//Origin_Root")?.isPaused = false
            addChild(node)
        }
    }
    
    @objc func addSubNode(_ tap: UITapGestureRecognizer) {
        
        if let originRootNode = referenceNode?.childNode(withName: "//Origin_Root") {
            
            originRootNode.removeFromParent()
            originRootNode.isPaused = false
            retainer = originRootNode
        }
        
        if let node = retainer { addChild(node) }
    }
    
    @objc func clear(_ tap: UITapGestureRecognizer) {
        
        self.removeAllChildren()
    }
}
