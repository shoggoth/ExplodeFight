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
import GameControls

class AttractScene: BaseSKScene {
    
    lazy var modeScene: SKScene? = { SKScene(fileNamed: "AttractModes") }()
    
    private var controllerManager: GameControllerManager?

    #if os(iOS)
    override var requiredScaleMode: SKSceneScaleMode { UIScreen.main.traitCollection.userInterfaceIdiom == .pad ? .aspectFill : .aspectFit }
    #endif
    
    private var stateMachine: GKStateMachine!
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        #if os(iOS)
        if UIScreen.main.traitCollection.userInterfaceIdiom == .pad { self.childNode(withName: "//Camera")?.setScale(1.33333) }
        #endif

        // Set up user control
        Global.controllerManager.handler = { pad, element in if pad.buttonA.isPressed { self.startGame() }}

        #if os(iOS) || os(tvOS)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(start)))
        #endif
        
        // Force explode shader load
        if let explodeNode = childNode(withName: "DummyExplode") as? SKSpriteNode { Global.explodeShader.preload(node: explodeNode) }
        
        // Advance starfield sim time
        if let starField = childNode(withName: "//StarField") as? SKEmitterNode { starField.advanceSimulationTime(5) }
        
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
    
    private func startGame() {
        
        let transition = SKTransition.crossFade(withDuration: 0.23)
        transition.pausesIncomingScene = false
        
        DispatchQueue.main.async { self.view?.load(sceneWithFileName: "GameScene", transition: transition) }
    }
    
    #if os(iOS) || os(tvOS)
    @objc func start(_ tap: UITapGestureRecognizer) { startGame() }
    #endif
    
    override func update(deltaTime: TimeInterval) {
        
        stateMachine.update(deltaTime: deltaTime)
        
        super.update(deltaTime: deltaTime)
    }
    
    // MARK: - States -
    
    static var spielIndex = 0
    
    private class ShowExplanation: CountdownState {
        
        init(sourceNode: SKNode, destinationNode: SKNode) {
            
            super.init(enter: {
                
                destinationNode.addChild(sourceNode)
                
                let spiels = [
                    ["this is going to be a twin stick shooter for the ios",
                     "inspired by robotron 2084 and crystal quest",
                     "created by rich henry at dogstar industries ltd.",
                     "thank you everyone for your valuable feedback."],
                    
                    ["just how long can i make a line of text I wonder?",
                     "looks like it might be 64 characters on a 16:9 screen",
                     "what about the iPad though? Is this going to be too long??",
                     "there can be quite a lot of lines of text too, even if we",
                     "start near the middle of the screen",
                     "and keep adding lines",
                     "until the bottom is near",
                     "has an extra line here :lol: 🍄"]
                    ,
                   
                   ["greetings to all friends, past and present",
                    "hccs, vic, stoffer, doobs, sean, biff, others.",
                    "",
                    "there is a blank line above this line.",
                    "👍🏻 two thumbs fresh 👍🏻"]
                ]
                
                let textStrings = spiels[spielIndex % spiels.count]
                let revealTime = 2.3
                let fadeTime = 0.23
                
                sourceNode.addChild(makeRevealer(text: textStrings, rt: revealTime, ft: fadeTime))
                sourceNode.isPaused = false
                
                spielIndex += 1
                
                return CountdownTimer(countDownTime: revealTime * Double(textStrings.count) + fadeTime)
            },
            
            expire: { stateMachine in
                
                sourceNode.removeFromParent()
                stateMachine?.enter(ShowHiScores.self) }
            )
        }
    }
    
    private class ShowHiScores: CountdownState {
        
        init(sourceNode: SKNode, destinationNode: SKNode) {
            
            super.init(enter: {
                
                destinationNode.addChild(sourceNode)
                
                var yPos = CGFloat(-48)
                ScoreManager.loadHiScores() { _, scores in
                    
                    scores?.forEach { score in
                        
                        let label = SKLabelNode(text: "\(score.player.alias) : \(score.value)")
                        label.alpha = 1.0
                        label.fontName = "Robotron"
                        label.fontSize = 24
                        label.position = CGPoint(x: 0, y: yPos)
                        label.horizontalAlignmentMode = .center
                        label.verticalAlignmentMode = .baseline
                        
                        sourceNode.addChild(label)
                        
                        yPos -= 24
                    }
                    
                    sourceNode.isPaused = false
                }
                
                return CountdownTimer(countDownTime: 5.0)
            },
            
            expire: { stateMachine in
                
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
            
            expire: { stateMachine in
                
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
            
            expire: { stateMachine in
                
                sourceNode.removeFromParent()
                stateMachine?.enter(ShowExplanation.self) }
            )
        }
    }
}

