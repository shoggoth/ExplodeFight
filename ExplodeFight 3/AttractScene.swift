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

class AttractScene : BaseSKScene {
    
    var stateMachine = GKStateMachine(states: [ShowEnemies(), ShowHiScores()])
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // TODO: Could an SKAction be used to make this transition?
        // DispatchQueue.main.asyncAfter(deadline: .now() + timeUntilNextPhase) { self.view?.load(sceneWithFileName: GameViewController.config.initialSceneName, transition: transition) }
        
        // Set up user control
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(start)))
        //view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(clear)))

        // Set up scene physics
        //self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        stateMachine.enter(ShowEnemies.self)
    }
    
    @objc func start(_ tap: UITapGestureRecognizer) {

        let transition = SKTransition.crossFade(withDuration: 0.23)
        transition.pausesIncomingScene = false

        DispatchQueue.main.async { self.view?.load(sceneWithFileName: "GameScene", transition: transition) }
    }

    override func update(delta: TimeInterval) {
        
        stateMachine.update(deltaTime: delta)
        
        super.update(delta: delta)
    }
}

// MARK: - State Machine States

private class ShowEnemies: GKState {
    
    override func didEnter(from previousState: GKState?) {
        
        print("gonna show enemies tbh lad")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        return true
    }
}

private class ShowHiScores: GKState {
    
    override func didEnter(from previousState: GKState?) {
        
        print("gonna show some of the high scores tbh lad")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        print("updating")
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        return true
    }
}
