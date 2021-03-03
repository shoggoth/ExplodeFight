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
    
    override var requiredScaleMode: SKSceneScaleMode { .aspectFit }
    
    private let joystick = TouchJoystick()
    
    override func didMove(to view: SKView) {
        
        // Set up scene physics
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        // Setup entities
        if let node = scene?.childNode(withName: "Player") {
            
            let playerEntity = PlayerEntity(withNode: node)
            playerEntity.addComponent(PlayerControlComponent(joystick: joystick))

            entities.append(playerEntity)
        }
        
        if let node = scene?.childNode(withName: "Mob") { entities.append(MobEntity(withNode: node)) }
        
        tilemapbits()
    }
    
    private func tilemapbits() {
        
        guard let edNode = scene?.childNode(withName: "CharacterTileMap") as? SKTileMapNode else { return }
        guard let prNode = scene?.childNode(withName: "ProgrTMRoot") else { return }
        
        makeTileMap(on: prNode)
    }
    
    private func makeTileMap(on node: SKNode) {
        
        print("making programmatic tile map... \(node)")
        
        // Create tile sets
        let groups = ["0", "1"].map { SKTileGroup(tileDefinition: SKTileDefinition(texture: SKTexture(imageNamed: $0))) }
        let tileSet = SKTileSet(tileGroups: groups)
        tileSet.defaultTileSize = CGSize(width: 32, height: 32)
        
        // Create tile map
        let tileMap = SKTileMapNode(tileSet: tileSet, columns: 40, rows: 4, tileSize: tileSet.defaultTileSize)
        tileMap.fill(with: groups.first)
        
        // Add it to the scene
        node.addChild(tileMap)
        
        print("mog \(groups)")
        print("mog \(tileSet)")
    }
}

// MARK: - Touch handling

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesBegan(touches, with: event) }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesMoved(touches, with: event) }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesEnded(touches, with: event) }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesCancelled(touches, with: event) }
}
