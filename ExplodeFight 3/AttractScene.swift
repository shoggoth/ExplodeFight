//
//  AttractScene.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 15/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons
import GameplayKit

class AttractScene: BaseSKScene {
    
    lazy var modeScene : SKScene? = { SKScene(fileNamed: "AttractModes") }()
    
    private var stateMachine: GKStateMachine!

    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // TODO: Could an SKAction be used to make this transition?
        // DispatchQueue.main.asyncAfter(deadline: .now() + timeUntilNextPhase) { self.view?.load(sceneWithFileName: GameViewController.config.initialSceneName, transition: transition) }
        
        // Set up user control
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(start)))
        
        let findSourceNode = { name in self.modeScene?.orphanedChildNode(withName: name) }
        
        stateMachine = GKStateMachine(states: [
            ShowEnemies(sourceNode: findSourceNode("EnemiesRoot")!, destinationNode: self),
            ShowHiScores(sourceNode: findSourceNode("HiScoreRoot")!, destinationNode: self),
            ShowPlayDemo(sourceNode: findSourceNode("OffsetRoot/PlayDemoRoot")!, destinationNode: self)
        ])
        stateMachine.enter(ShowHiScores.self)
        
        // TODO: remove this
        tilemapbits()
    }
    
    @objc func start(_ tap: UITapGestureRecognizer) {

        let transition = SKTransition.crossFade(withDuration: 0.23)
        transition.pausesIncomingScene = false

        DispatchQueue.main.async { self.view?.load(sceneWithFileName: "GameScene", transition: transition) }
    }

    override func update(deltaTime: TimeInterval) {
        
        stateMachine.update(deltaTime: deltaTime)
        
        super.update(deltaTime: deltaTime)
    }
}

// MARK: -

extension AttractScene {
    
    private func tilemapbits() {
        
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
        
        tileMap.run(SKAction.sequence([SKAction.wait(forDuration: 3.0),
                                       SKAction.run { mapper.print(key: "_plus", to: tileMap, at: CGPoint(x: 3, y: 3)) },
                                       SKAction.wait(forDuration: 3.0),
                                       SKAction.run { mapper.print(keys: "DEAD CABBAGE".map { String($0) }, to: tileMap, at: CGPoint(x: 18, y: 0)) },
                                       SKAction.wait(forDuration: 100.0),
                                       SKAction.removeFromParent()]))
    }
}

// MARK: - State Machine States -

private class ShowEnemies: AttractState {
    
    override func didEnter(from previousState: GKState?) {
        
        super.didEnter(from: previousState)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { self.stateMachine?.enter(ShowHiScores.self) }
    }
}

private class ShowHiScores: AttractState {
    
    override func didEnter(from previousState: GKState?) {
        
        super.didEnter(from: previousState)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { self.stateMachine?.enter(ShowPlayDemo.self) }
    }
}

private class ShowPlayDemo: AttractState {
    
    override func didEnter(from previousState: GKState?) {
        
        super.didEnter(from: previousState)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { self.stateMachine?.enter(ShowEnemies.self) }
    }
}

// MARK: -

private class AttractState: GKState {

    let src: SKNode
    let dst: SKNode

    init(sourceNode: SKNode, destinationNode: SKNode) {
        
        self.src = sourceNode
        self.dst = destinationNode
        
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
        dst.addChild(src)
        src.isPaused = false
    }
    
    override func willExit(to nextState: GKState) {
        
        src.removeFromParent()
    }
}
