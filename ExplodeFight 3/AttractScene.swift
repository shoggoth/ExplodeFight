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
    
    lazy var modeScene: SKScene? = { SKScene(fileNamed: "AttractModes") }()
    
    override var requiredScaleMode: SKSceneScaleMode { .aspectFit }

    private var stateMachine: GKStateMachine!

    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // TODO: Could an SKAction be used to make this transition?
        // DispatchQueue.main.asyncAfter(deadline: .now() + timeUntilNextPhase) { self.view?.load(sceneWithFileName: GameViewController.config.initialSceneName, transition: transition) }
        
        // Set up user control
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(start)))
        
        let findSourceNode = { name in self.modeScene?.orphanedChildNode(withName: name) }
        
        stateMachine = GKStateMachine(states: [
            ShowExplanation(sourceNode: findSourceNode("ExplanationRoot")!, destinationNode: self),
            ShowEnemies(sourceNode: findSourceNode("EnemiesRoot")!, destinationNode: self),
            ShowHiScores(sourceNode: findSourceNode("HiScoreRoot")!, destinationNode: self),
            ShowPlayDemo(sourceNode: findSourceNode("OffsetRoot/PlayDemoRoot")!, destinationNode: self)
        ])
        stateMachine.enter(ShowExplanation.self)
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
    
    // MARK: - States -

    private class ShowExplanation: CountdownState {
        
        init(sourceNode: SKNode, destinationNode: SKNode) {
            
            super.init(enter: {
                
                destinationNode.addChild(sourceNode)
                sourceNode.isPaused = false

                let nodeNames = ["Text_1", "Text_2", "Text_3"]
                let revealTime = 2.3
                let fadeTime = 0.23
                
                nodeNames.enumerated().forEach {
                    
                    if let node = sourceNode.childNode(withName: $0.1) {
                        
                        node.removeAllActions()
                        node.alpha = 1.0
                        node.run(SKAction.sequence([SKAction.wait(forDuration: revealTime * Double(nodeNames.count)), SKAction.fadeOut(withDuration: fadeTime)]))
                    }
                    
                    if let node = sourceNode.childNode(withName: "\($0.1)/Revealer") {
                        
                        node.position.x = 0
                        node.run(SKAction.sequence([SKAction.wait(forDuration: Double($0.0) * revealTime), SKAction.move(by: CGVector(dx: 1024, dy: 0), duration: revealTime)]))
                    }
                }

                return CountdownTimer(countDownTime: revealTime * Double(nodeNames.count) + fadeTime)
            },
            
            exit: { stateMachine in
                
                sourceNode.removeFromParent()
                stateMachine?.enter(ShowHiScores.self) }
            )
        }
    }

    private class ShowHiScores: CountdownState {
        
        init(sourceNode: SKNode, destinationNode: SKNode) {
            
            super.init(enter: {
                
                destinationNode.addChild(sourceNode)
                
                ScoreManager.loadHiScores() { _, scores in
                    
                    print("Scores: \(String(describing: scores))")
                    
                    sourceNode.isPaused = false
                }
                
                return CountdownTimer(countDownTime: 5.0)
            },
            
            exit: { stateMachine in
                
                sourceNode.removeFromParent()
                stateMachine?.enter(ShowEnemies.self) }
            )
        }
    }

    private class ShowEnemies: CountdownState {
        
        init(sourceNode: SKNode, destinationNode: SKNode) {
            
            super.init(enter: {
                
                destinationNode.addChild(sourceNode)
                sourceNode.isPaused = false

                return CountdownTimer(countDownTime: 3.0)
            },
            
            exit: { stateMachine in
                
                sourceNode.removeFromParent()
                stateMachine?.enter(ShowPlayDemo.self) }
            )
        }
    }

    private class ShowPlayDemo: CountdownState {
        
        init(sourceNode: SKNode, destinationNode: SKNode) {
            
            super.init(enter: {
                
                destinationNode.addChild(sourceNode)
                sourceNode.isPaused = false

                return CountdownTimer(countDownTime: 3.0)
            },
            
            exit: { stateMachine in
                
                sourceNode.removeFromParent()
                stateMachine?.enter(ShowExplanation.self) }
            )
        }
    }
}

