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
    
    var level: Level?

    override var requiredScaleMode: SKSceneScaleMode { .aspectFit }
    
    private var score = Score(dis: 0, acc: 0)
    private var scoreLabel: SKLabelNode?
    
    var spawnTicker: PeriodicTimer? = PeriodicTimer(tickInterval: 1.7)
    let mobSpawner = SceneSpawner(scene: SKScene(fileNamed: "Mobs")!)

    private let joystick = TouchJoystick()
    
    override func didMove(to view: SKView) {
        
        // Global setup
        Global.soundManager.playNode = self

        // Set up scene physics
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)

        // Setup HUD
        scoreLabel = (self.childNode(withName: "Camera/Score") as? SKLabelNode)
        
        // Setup Player
        if let node = childNode(withName: "Player"), let entity = node.entity {
            
            entity.addComponent(GKAgent2D(node: node, maxSpeed: 600, maxAcceleration: 20, radius: 20, mass: Float(node.physicsBody?.mass ?? 1)))
            entity.addComponent(PlayerControlComponent(joystick: joystick))
        }

        // Create initial level
        loadNextLevel()
    }
    
    override func update(deltaTime: TimeInterval) {
        
        mobSpawner.update(deltaTime: deltaTime)
        level?.update(deltaTime: deltaTime, scene: self)
        
        if score.acc > 0 {
            
            score = score.tick() { displayScore in self.scoreLabel?.text = "SCORE: \(displayScore)" }
            
            // ScoreManager.updateChieve(id: "millionaire", percent: 100)
        }
        
        super.update(deltaTime: deltaTime)
    }
    
    func updateRules(ruleSystem: GKRuleSystem) {
        
        ruleSystem.state["mobCount"] = mobSpawner.activeCount
    }
    
    func loadNextLevel() {
        
        level = StateDrivenLevel(name: "Test level", states: [
            
            StateDrivenLevel.PlayState() {
                
                self.level?.teardown(scene: self)

                return CountdownTimer(countDownTime: 15.0)
            },
            StateDrivenLevel.CountState() {
                
                self.level?.postamble(scene: self)
            },
            StateDrivenLevel.EndedState() { [self] in
                
                mobSpawner.kill()
                loadNextLevel()
            }
        ])
        
        level?.setup(scene: self)
    }

    func spawn(name: String) {
        
        if let spawner = mobSpawner.spawner(named: name) {

            let mobDesc = Mob(name: name, maxSpeed: 600, pointValue: 100)

            if let newNode = spawner.spawn(completion: { node in
                
                let mobEntity = GKEntity()
                
                mobEntity.addComponent(GKSKNodeComponent(node: node))
                mobEntity.addComponent(GKAgent2D(node: node, maxSpeed: mobDesc.maxSpeed, maxAcceleration: 20, radius: 20, mass: Float(node.physicsBody?.mass ?? 1), behaviour: GKBehavior(goal: GKGoal(toWander: Float.random(in: -1.0 ... 1.0) * 600), weight: 100.0)))
                mobEntity.addComponent(MobComponent(states: mobDesc.makeStates(node: node, scene: self, spawner: spawner)))
                
                return mobEntity
            
            }) { addChild(newNode) }
        }
    }
    
    func addScore(score s: Int64) {
        
        score = score.add(add: s)
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
