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
        
        // Set up user control
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(start)))
        
        // Force explode shader load
        if let explodeNode = childNode(withName: "DummyExplode") as? SKSpriteNode {
            
            Global.explodeShader.explode(node: explodeNode, toScale: vector_float2(1, 1), withSplits: vector_float2(1, 1), duration: 0)
        }
        
        // Set up state phases
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

                let textStrings = ["this is Going to be a twin stick shooter for the ios",
                                   "inspired by robotron 2084 and crystal quest",
                                   "created by rich henry at dogstar industries ltd.",
                                   "thank you everyone for your valuable feedback."]
                let revealTime = 2.3
                let fadeTime = 0.23
                
                sourceNode.addChild(makeRevealer(text: textStrings, rt: revealTime, ft: fadeTime))
                sourceNode.isPaused = false

                return CountdownTimer(countDownTime: revealTime * Double(textStrings.count) + fadeTime)
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

