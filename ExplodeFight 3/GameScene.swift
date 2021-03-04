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
        
        // Shader?
        edNode.shader = SKShader(fileNamed: "charMap.fsh")

        makeTileMap(on: prNode)
    }
    
    private func makeTileMap(on node: SKNode) {
        
        let mapper = CharTileSetMapper(alphabet: "ABCDW6720", defaultSize: CGSize(width: 32, height: 32))

        // Create tile map
        let tileMap = SKTileMapNode(tileSet: mapper.tileSet, columns: 32, rows: 4, tileSize: mapper.tileSet.defaultTileSize)
        tileMap.fill(with: mapper.tiles["W"])
        tileMap.setTileGroup(mapper.tiles["A"], forColumn: 1, row: 1)
        tileMap.setTileGroup(mapper.tiles["B"], forColumn: 0, row: 2)
        tileMap.setTileGroup(mapper.tiles["C"], forColumn: 1, row: 3)
        
        // Add it to the scene
        node.addChild(tileMap)
        tileMap.run(SKAction.sequence([SKAction.wait(forDuration: 3.0),
                                       SKAction.run { tileMap.setTileGroup(mapper.tiles["D"], forColumn: 3, row: 3) },
                                       SKAction.wait(forDuration: 1.0),
                                       SKAction(named: "TMAnimation")!]))
    }
}

struct CharTileSetMapper {
    
    let tiles: [String : SKTileGroup]
    let tileSet: SKTileSet

    init(alphabet: String, defaultSize: CGSize) {
        
        tiles = Dictionary(uniqueKeysWithValues: alphabet.map { (String($0), SKTileGroup(tileDefinition: SKTileDefinition(texture: SKTexture(imageNamed: String($0))))) })
        tileSet = SKTileSet(tileGroups: tiles.map { $0.1 })
        tileSet.defaultTileSize = defaultSize
    }
}

// MARK: - Touch handling

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesBegan(touches, with: event) }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesMoved(touches, with: event) }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesEnded(touches, with: event) }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesCancelled(touches, with: event) }
}
