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

    override var requiredScaleMode: SKSceneScaleMode { UIScreen.main.traitCollection.userInterfaceIdiom == .pad ? .aspectFill : .aspectFit }

    var level: Level?
    var playerEntity: GKEntity?
    let joystick = TouchJoystick()

    var mobRootNode: SKNode { childNode(withName: "MobRoot")! }
    var playerRootNode: SKNode { childNode(withName: "PlayerRoot")! }
    
    lazy var interstitial = { Interstitial(scene: self) }()

    private var men = Defaults.initialNumberofMen
    private var menLabel: SKLabelNode?

    private var score = Score(dis: 0, acc: 0)
    private var scoreLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {

        if UIScreen.main.traitCollection.userInterfaceIdiom == .pad { self.childNode(withName: "//Camera")?.setScale(1.33333) }

        // Global setup
        Global.soundManager.playNode = self
        
        // Set up scene physics
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        // Setup HUD
        scoreLabel = (self.childNode(withName: "Camera/Score") as? SKLabelNode)
        menLabel = (self.childNode(withName: "Camera/Men") as? SKLabelNode)
        menLabel?.text = "MEN: \(men)"

        // Setup Player
        Player.createPlayer(scene: self)

        // Create initial level
        loadNextLevel()
        
        // This seems to stop nodes inside the reference being paused when the scene appears.
        // https://stackoverflow.com/questions/47615847/xcode-9-1-and-9-2-referenced-sprites-are-not-executing-actions-added-in-scen
        isPaused = true
        isPaused = false
    }
    
    override func update(deltaTime: TimeInterval) {
        
        level?.update(deltaTime: deltaTime, scene: self)
        
        if score.acc > 0 {
            
            score = score.tick() { displayScore in self.scoreLabel?.text = "SCORE: \(displayScore)" }
            
            // ScoreManager.updateChieve(id: "millionaire", percent: 100)
        }
        
        super.update(deltaTime: deltaTime)
    }
    
    // MARK: Level events

    func loadNextLevel() {
        
        level = StateDrivenLevel(levelNum: (level?.levelNum ?? 0) + 1, name: "Unnamed", states: [
            
            StateDrivenLevel.PlayState(scene: self),
            StateDrivenLevel.BonusState(scene: self),
            StateDrivenLevel.EndedState(scene: self)
        ])
        
        level?.setup(scene: self)
    }
    
    // MARK: Score events

    func addScore(score s: Int64) {
        
        score = score.add(add: s)
    }
    
    // MARK: Game events
    
    func playerDeath() {
        
        men -= 1
        self.menLabel?.text = "MEN: \(men)"

        if men <= 0 { gameOver() }
    }
    
    private func gameOver() {
        
        // Level nullify
        level?.teardown(scene: self)
        level = nil

        // Fade all mobs
        mobRootNode.run(.fadeOut(withDuration: 1))

        // Game over message and scene load action.
        interstitial.flashupNode(named: "GameOver", action: .sequence([.unhide(), .wait(forDuration: 5.0), SKAction(named: "ZoomFadeOut")!, .hide(), .run {
            
            DispatchQueue.main.async { self.view?.load(sceneWithFileName: GameViewController.config.initialSceneName) }

        }]))

        Player.destroyPlayer(scene: self)
        
        ScoreManager.submitHiScore(boardIdentifier: "hiScore", score: score)
    }
}

// MARK: - Button press handling -

extension GameScene: ButtonSKSpriteNodeResponder {
    
    func buttonTriggered(button: ButtonSKSpriteNode) {
        
        isPaused = !isPaused
    }
}

// MARK: - Contact handling -

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let a = contact.bodyA.node, let b = contact.bodyB.node else { return }
        
        a.contactWithNodeDidBegin(b)
        b.contactWithNodeDidBegin(a)
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        guard let a = contact.bodyA.node, let b = contact.bodyB.node else { return }

        a.contactWithNodeDidEnd(b)
        b.contactWithNodeDidEnd(a)
    }
}

// MARK: - Touch handling -

extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesBegan(touches, with: event) }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesMoved(touches, with: event) }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesEnded(touches, with: event) }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) { joystick.touchesCancelled(touches, with: event) }
}
