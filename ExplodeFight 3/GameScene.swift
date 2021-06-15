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
    
    var level: Level?
    var player: SKNode?

    var mobRootNode: SKNode { childNode(withName: "MobRoot")! }
    var interstitialRootNode: SKNode { childNode(withName: "ISRoot")! }
    
    private var men = Defaults.initialNumberofMen
    private var menLabel: SKLabelNode?

    private var score = Score(dis: 0, acc: 0)
    private var scoreLabel: SKLabelNode?

    private let joystick = TouchJoystick()
    
    override func didMove(to view: SKView) {
        
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
        createPlayer()

        // Create initial level
        loadNextLevel()
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
            
            StateDrivenLevel.PlayState() {
                
                self.level?.teardown(scene: self)

                return CountdownTimer(countDownTime: 10.0)
            },
            StateDrivenLevel.BonusState() { self.level?.postamble(scene: self) },
            StateDrivenLevel.EndedState() { if self.level != nil { self.loadNextLevel() }},
        ])
        
        level?.setup(scene: self)
    }
    
    // MARK: Score events

    func addScore(score s: Int64) {
        
        score = score.add(add: s)
    }
    
    // MARK: Game events
    
    private func gameOver() {
        
        // Level nullify
        level?.teardown(scene: self)
        level = nil
        
        // Game over message and scene load action.
        if let node = Interstitial.gameOverNode {
            
            node.reset() { _ in
                node.run(.sequence([.wait(forDuration: 5.0), SKAction(named: "ZoomFadeOut")!, .removeFromParent(), .run {
                    
                    DispatchQueue.main.async { self.view?.load(sceneWithFileName: GameViewController.config.initialSceneName) }

                }]))
                node.isPaused = false
            }
            
            mobRootNode.run(.fadeOut(withDuration: 1))
            interstitialRootNode.addChild(node)
        }
        
        destroyPlayer()
        
        ScoreManager.submitHiScore(boardIdentifier: "hiScore", score: score)
    }
}

// MARK: - Player functions -

extension GameScene {
    
    func createPlayer() {
        
        player = {
            if let node = childNode(withName: "Player"), let entity = node.entity {
                
                let playerDesc = Player(name: "Player", maxSpeed: 600, pointValue: 100, position: node.position, rotation: node.zRotation)
                
                entity.addComponent(GKAgent2D(node: node, maxSpeed: 600, maxAcceleration: 20, radius: 20, mass: Float(node.physicsBody?.mass ?? 1)))
                entity.addComponent(PlayerControlComponent(joystick: joystick))
                entity.addComponent(StateComponent(states: playerDesc.makeStates(node: node, scene: self)))
                entity.addComponent(ContactComponent { node in
                    
                    if node.physicsBody?.categoryBitMask ?? 0 | 4 != 0 { print("Player picking up something.") }
                    if node.name == "Ship" { entity.component(ofType: StateComponent.self)?.stateMachine.enter(PlayerState.ExplodeState.self) }
                })
                
                return node
            }
            
            return nil
        }()
    }
    
    func destroyPlayer() {
        
        childNode(withName: "Player")?.removeFromParent()
    }
    
    func playerDeath() {
        
        men -= 1
        self.menLabel?.text = "MEN: \(men)"

        if men <= 0 { gameOver() }
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
