//
//  Level.swift
//  EF3
//
//  Created by Richard Henry on 12/03/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

protocol Level {
    
    // Description
    var name: String { get }
    
    // Properties
    var ruleSystem: GKRuleSystem { get }
    
    // Functionality
    func setup(scene: GameScene)
    func update(deltaTime: TimeInterval, scene: GameScene)
    func postamble(scene: GameScene)
    func teardown(scene: GameScene)
}

// MARK: -

struct StateDrivenLevel: Level {
    
    let name: String

    internal let ruleSystem = GKRuleSystem()
    private let stateMachine: GKStateMachine
    
    private let mobSpawner = SceneSpawner(scene: SKScene(fileNamed: "Mobs")!)

    init(name: String, states: [GKState]) {
        
        self.name = name
        
        stateMachine = GKStateMachine(states: states)
        if let firstState = states.first { stateMachine.enter(type(of: firstState)) }
        
        // Setup level rules
        ruleSystem.add(GKRule(predicate: NSPredicate(format: "$mobCount.intValue < 100"), assertingFact: "mobCountIsLow" as NSObject, grade: 1.0))
        ruleSystem.add(GKRule(predicate: NSPredicate(format: "$mobCount.intValue == 0"), assertingFact: "allMobsDestroyed" as NSObject, grade: 1.0))
    }
    
    func setup(scene: GameScene) {
        
        if let node = GameScene.getReadyNode {
            
            scene.addChild(node)
            node.run(.sequence([SKAction.customAction(withDuration: 0) { node, _ in node.reset() }, SKAction.wait(forDuration: 1.0), SKAction(named: "ZoomFadeOut")!, SKAction.removeFromParent()]))
            node.isPaused = false
        }
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        
        stateMachine.update(deltaTime: deltaTime)
        
        ruleSystem.reset()
        ruleSystem.state["mobCount"] = mobSpawner.activeCount
        ruleSystem.evaluate()
        
        mobSpawner.update(deltaTime: deltaTime)

        // TODO: Move this elsewhere
        if ruleSystem.grade(forFact: "mobCountIsLow" as NSObjectProtocol) >= 1.0 {
            
            spawnTicker = spawnTicker?.tick(deltaTime: deltaTime) {
                
                func spawn(name: String) {
                    
                    if let spawner = mobSpawner.spawner(named: name) {

                        let mobDesc = Mob(name: name, maxSpeed: 600, pointValue: 100)

                        let entitySetup: (SKNode) -> GKEntity = { node in
                            
                            let mobEntity = GKEntity()
                            
                            mobEntity.addComponent(GKSKNodeComponent(node: node))
                            mobEntity.addComponent(GKAgent2D(node: node, maxSpeed: mobDesc.maxSpeed, maxAcceleration: 20, radius: 20, mass: Float(node.physicsBody?.mass ?? 1), behaviour: GKBehavior(goal: GKGoal(toWander: Float.random(in: -1.0 ... 1.0) * 600), weight: 100.0)))
                            mobEntity.addComponent(MobComponent(states: mobDesc.makeStates(node: node, scene: scene, spawner: spawner)))
                            
                            return mobEntity
                        
                        }
                        
                        if let newNode = spawner.spawn(completion: { node in
                            
                            return entitySetup(node)
                        
                        }) { scene.addChild(newNode) }
                    }
                }
                
                func wave(s: String) {
                    
                    let f: (CGPoint) -> Void = { p in
                        
                        if let spawner = mobSpawner.spawner(named: s) {

                            let mobDesc = Mob(name: s, maxSpeed: 600, pointValue: 100)

                            let entitySetup: (SKNode) -> GKEntity = { node in
                                
                                let mobEntity = GKEntity()
                                
                                mobEntity.addComponent(GKSKNodeComponent(node: node))
                                mobEntity.addComponent(GKAgent2D(node: node, maxSpeed: mobDesc.maxSpeed, maxAcceleration: 20, radius: 20, mass: Float(node.physicsBody?.mass ?? 1), behaviour: GKBehavior(goal: GKGoal(toWander: Float.random(in: -1.0 ... 1.0) * 600), weight: 100.0)))
                                mobEntity.addComponent(MobComponent(states: mobDesc.makeStates(node: node, scene: scene, spawner: spawner)))
                                
                                return mobEntity
                            
                            }
                            
                            if let newNode = spawner.spawn(completion: { node in
                                
                                return entitySetup(node)
                            
                            }) {
                                newNode.position = p
                                newNode.zRotation = CGVector(point: p).angle
                                scene.addChild(newNode)
                            }
                        }
                    }
                    
                    PointPattern.circle(divs: 8).trace(size: 64, with: f)
                }

                wave(s: ["Ship", "Mob", "AniMob", "Robot"][Int.random(in: 0...3)])
            }
        }
    }
    
    func postamble(scene: GameScene) {
        
        scene.addScore(score: 31337)
        
        if let node = GameScene.postambleNode {
            
            scene.addChild(node)
            node.reset()
            
            node.run(.sequence([SKAction.wait(forDuration: 10.0),
                                SKAction(named: "ZoomFadeOut")!,
                                SKAction.removeFromParent(),
                                SKAction.customAction(withDuration: 0) { _, _ in stateMachine.enter(EndedState.self) }]))
            node.isPaused = false
        }
    }
    
    func teardown(scene: GameScene) {
        
        mobSpawner.kill()
        print("Tearing down level in \(scene)")
    }
}

private var spawnTicker: PeriodicTimer? = PeriodicTimer(tickInterval: 1.7)

extension StateDrivenLevel {
    
    class PlayState: CountdownState {
        
        init(completion: (() -> CountdownTimer?)? = nil) { super.init(enter: completion, exit: { stateMachine in stateMachine?.enter(CountState.self) }) }
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is EndedState.Type || stateClass is CountState.Type }
        
        override func update(deltaTime: TimeInterval) {
            
            super.update(deltaTime: deltaTime)
        }
    }
    
    class CountState: GKState {
        
        private var countFunc: (() -> Void)?
        
        init(completion: (() -> Void)? = nil) { countFunc = completion }

        override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is EndedState.Type }
        
        override func didEnter(from previousState: GKState?) { countFunc?() }
    }
    
    class EndedState: GKState {
        
        private var endFunc: (() -> Void)?
        
        init(completion: (() -> Void)? = nil) { endFunc = completion }
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { false }
        
        override func didEnter(from previousState: GKState?) { endFunc?() }
    }
}
