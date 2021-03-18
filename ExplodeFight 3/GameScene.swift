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
    
    private lazy var cloneNode = { self.childNode(withName: "Original") }()
    private lazy var spawnNode = { self.childNode(withName: "Spawner_0") }()
    
    private var spawner: Spawner?
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // Set up user control
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spawn)))
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(clear)))
        
        // Set up scene physics
        self.physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
        
        spawner = Spawner(node: cloneNode!)
        spawner?.autoAddSpriteComponent = true
    }
    
    @objc func spawn(_ tap: UITapGestureRecognizer) {
        
        spawnOne()
    }
    
    @objc func clear(_ tap: UITapGestureRecognizer) {
        
        if tap.state == .began {
            
            // Remove entity of the clone source node.
            if let entity = cloneNode?.entity, let i = entities.firstIndex(of: entity) { entities.remove(at: i) }

            spawner?.kill()
        }
        
        else if tap.state == .ended {
            
            // Remove clone source node.
            cloneNode?.removeFromParent()
            cloneNode = nil
        }
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        spawner?.update(deltaTime: deltaTime)
    }
}

// MARK: - Spawn robots -

extension GameScene {
    
    func spawnOne() {
        
        if let node = spawner?.spawn(completion: { node in
            
            let entity = GKEntity()
            
            entity.addComponent(DebugComponent())
            entity.addComponent(AIComponent(states: [LiveState(), ExplodeState(), DieState(), DebugState(name: "Anon")]))

            return entity
        }) {
            node.position = CGPoint.zero
            spawnNode?.addChild(node)
        }
    }
}
