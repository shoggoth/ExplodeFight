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
        //view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(clear)))

        // Set up scene physics
        //self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        let findSourceNode = { name in self.modeScene?.orphanedChildNode(withName: name) }
        
        stateMachine = GKStateMachine(states: [
            ShowEnemies(sourceNode: findSourceNode("EnemiesRoot")!, destinationNode: self),
            ShowHiScores(sourceNode: findSourceNode("HiScoreRoot")!, destinationNode: self),
            ShowPlayDemo(sourceNode: findSourceNode("OffsetRoot/PlayDemoRoot")!, destinationNode: self)
        ])
        stateMachine.enter(ShowHiScores.self)
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

// MARK: - State Machine States

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
