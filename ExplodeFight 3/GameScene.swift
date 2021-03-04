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
        
        // Shader
        edNode.shader = SKShader(fileNamed: "charMap.fsh")

        // Procedural tilemap
        let mapper = CharacterTileSetMap(alphabet: "ABCEFGH".map { String($0) } + ["D", "W", "6", "7", "2", "0", "_plus", "_star"], defaultSize: CGSize(width: 32, height: 32))
        let tileMap = SKTileMapNode(tileSet: mapper.tileSet, columns: 32, rows: 4, tileSize: mapper.tileSet.defaultTileSize)
        
        // Add it to the scene
        prNode.addChild(tileMap)

        makeTileMap(on: tileMap, mapper: mapper)
    }
    
    private func makeTileMap(on tileMap: SKTileMapNode, mapper: CharacterTileSetMap) {
        
        tileMap.fill(with: mapper.tiles[" "])
        mapper.print(key: "A", to: tileMap, at: CGPoint(x: 1, y: 1))
        mapper.print(key: "B", to: tileMap, at: CGPoint(x: 12, y: 2))
        mapper.print(key: "C", to: tileMap, at: CGPoint(x: 15, y: 3))
        mapper.print(key: "D", to: tileMap, at: CGPoint(x: 2, y: 3))
        mapper.print(key: "_star", to: tileMap, at: CGPoint(x: 7, y: 3))
        
        mapper.print(key: "2", to: tileMap, at: CGPoint(x: 29, y: 2))
        mapper.print(keys: ["7", "2", "6", "0"], to: tileMap, at: CGPoint(x: 31, y: 2))
        mapper.print(keys: "CABBAGE DEAD FACE".map { String($0) }, to: tileMap, at: CGPoint(x: 0, y: 0))

        tileMap.run(SKAction.sequence([SKAction.wait(forDuration: 3.0),
                                       SKAction.run { mapper.print(key: "_plus", to: tileMap, at: CGPoint(x: 3, y: 3)) },
                                       SKAction.wait(forDuration: 100.0),
                                       SKAction(named: "TMAnimation")!]))
    }
}

struct CharacterTileSetMap {
    
    let tiles: [String : SKTileGroup]
    let tileSet: SKTileSet

    init(alphabet: [String], defaultSize: CGSize) {
        
        tiles = Dictionary(uniqueKeysWithValues: alphabet.map { ($0, SKTileGroup(tileDefinition: SKTileDefinition(texture: SKTexture(imageNamed: String($0))))) })
        tileSet = SKTileSet(tileGroups: tiles.map { $0.1 })
        tileSet.defaultTileSize = defaultSize
    }
    
    
    func print(key: String, to tileMap: SKTileMapNode, at: CGPoint) {
        
        let x = Int(at.x)
        let y = Int(at.y)
        
        guard x >= 0 && y >= 0 && x < tileMap.numberOfColumns && y < tileMap.numberOfRows else { fatalError("Character coordinates out of tilemap bounds.") }
        
        tileMap.setTileGroup(tiles[key], forColumn: x, row: tileMap.numberOfRows - y - 1)
    }

    func print(keys: [String], to tileMap: SKTileMapNode, at: CGPoint) {
        
        let x = Int(at.x)
        let y = Int(at.y)
        
        guard x >= 0 && y >= 0 && x < tileMap.numberOfColumns && y < tileMap.numberOfRows else { fatalError("Character coordinates out of tilemap bounds.") }
        
        keys.enumerated().forEach { (i, key) in tileMap.setTileGroup(tiles[key], forColumn: (x + i) % tileMap.numberOfColumns, row: tileMap.numberOfRows - y - 1) }
    }
}

extension SKTileMapNode {
    
    func bung(mapper: CharacterTileSetMap) { setTileGroup(mapper.tiles["_plus"], forColumn: 3, row: numberOfRows - 3) }
}

// MARK: - Touch handling

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesBegan(touches, with: event) }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesMoved(touches, with: event) }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesEnded(touches, with: event) }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesCancelled(touches, with: event) }
}
