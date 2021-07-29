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

    #if os(iOS)
    override var requiredScaleMode: SKSceneScaleMode { UIScreen.main.traitCollection.userInterfaceIdiom == .pad ? .aspectFill : .aspectFit }
    #endif
    
    var level: Level?
    var playerEntity: GKEntity?
    let joystick = RobotronControls(controllers: Global.controllerManager)

    var mobRootNode: SKNode { childNode(withName: "MobRoot")! }
    var playerRootNode: SKNode { childNode(withName: "PlayerRoot")! }
    
    lazy var interstitial = { Interstitial(scene: self) }()
    lazy var hud = { HUD(scene: self) }()

    private var men = Defaults.initialNumberofMen
    private var score = Score(dis: 0, acc: 0)
    
    override func didMove(to view: SKView) {

        #if os(iOS)
        if UIScreen.main.traitCollection.userInterfaceIdiom == .pad { self.childNode(withName: "//Camera")?.setScale(1.33333) }
        #endif

        // Global setup
        Global.soundManager.playNode = self
        
        // Set up scene physics
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

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
        
        if score.acc > 0 { score = score.tick() { s in self.hud.displayScore(score: s) }}
        
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

    func addScore(score s: Int64) { score = score.add(add: s) }
    
    // MARK: Game events
    
    func playerDeath() {
        
        men -= 1
        hud.displayMen(men: men)

        if men <= 0 { gameOver() }
    }
    
    private func gameOver() {
        
        // Level nullify
        level?.teardown(scene: self)
        level = nil

        // Fade all mobs
        mobRootNode.run(.fadeOut(withDuration: 1))

        // Game over message and scene load action.
        // TODO: Try this on release build, does it return to the splash?
        let sceneLoadAction = SKAction.run { DispatchQueue.main.async { self.view?.load(sceneWithFileName: GameViewController.config.initialSceneName) }}
        interstitial.flashupNode(named: "GameOver", action: .sequence([.unhide(), .wait(forDuration: 5.0), SKAction(named: "ZoomFadeOut")!, .hide(), sceneLoadAction]))

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
