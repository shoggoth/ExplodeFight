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

extension GameScene {
    
    func tilemapbits() {
        
        guard let parentNode = scene?.childNode(withName: "ProgrTMRoot") else { return }

        // Procedural tilemap
        let mapper = CharacterTileSetMap(alphabet: "ABCEFGH".map { String($0) } + ["D", "W", "6", "7", "2", "0", "_plus", "_star", "_comma"], defaultSize: CGSize(width: 32, height: 32))
        let tileMap = SKTileMapNode(tileSet: mapper.tileSet, columns: 32, rows: 4, tileSize: mapper.tileSet.defaultTileSize)
        
        // Add it to the scene
        parentNode.addChild(tileMap)

        makeTileMap(on: tileMap, mapper: mapper)
    }
    
    private func makeTileMap(on tileMap: SKTileMapNode, mapper: CharacterTileSetMap) {
        
        tileMap.fill(with: mapper.tiles[" "])
        mapper.print(key: "A", to: tileMap, at: CGPoint(x: 1, y: 1))
        mapper.print(key: "B", to: tileMap, at: CGPoint(x: 12, y: 2))
        mapper.print(key: "C", to: tileMap, at: CGPoint(x: 15, y: 3))
        mapper.print(key: "D", to: tileMap, at: CGPoint(x: 2, y: 3))
        mapper.print(key: "_star", to: tileMap, at: CGPoint(x: 7, y: 3))
        mapper.print(key: "_comma", to: tileMap, at: CGPoint(x: 8, y: 3))

        mapper.print(key: "2", to: tileMap, at: CGPoint(x: 29, y: 2))
        mapper.print(keys: ["7", "2", "6", "0"], to: tileMap, at: CGPoint(x: 31, y: 2))
        mapper.print(keys: "CABBAGE DEAD FACE".map { String($0) }, to: tileMap, at: CGPoint(x: 0, y: 0))

        tileMap.run(SKAction.sequence([.wait(forDuration: 3.0),
                                       .run { mapper.print(key: "_plus", to: tileMap, at: CGPoint(x: 3, y: 3)) },
                                       .wait(forDuration: 3.0),
                                       .run { mapper.print(keys: "DEAD CABBAGE".map { String($0) }, to: tileMap, at: CGPoint(x: 18, y: 0)) },
                                       .wait(forDuration: 3.0),
                                       SKAction(named: "TMAnimation")!,
                                       .removeFromParent()]))
    }
}
