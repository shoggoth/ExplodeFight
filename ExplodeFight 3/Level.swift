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
    
    // Functionality
    func setup(scene: GameScene)
    func update(deltaTime: TimeInterval, scene: GameScene)
    func postamble(scene: GameScene)
    func teardown(scene: GameScene)
}

// MARK: -

struct StateDrivenLevel: Level {
    
    let name: String
    
    private let stateMachine: GKStateMachine
    private let ruleSystem = GKRuleSystem()
    
    // TODO: Optimisation available
    private let getReadyNode = { SKScene(fileNamed: "Interstitial")?.orphanedChildNode(withName: "GetReady/Root") }()
    private let postambleNode = { SKScene(fileNamed: "Interstitial")?.orphanedChildNode(withName: "Bonus/Root") }()

    init(name: String, states: [GKState]) {
        
        self.name = name
        
        stateMachine = GKStateMachine(states: states)
        if let firstState = states.first { stateMachine.enter(type(of: firstState)) }
        
        // Setup level rules
        ruleSystem.add(GKRule(predicate: NSPredicate(format: "$mobCount.intValue < 10"), assertingFact: "mobCountIsLow" as NSObject, grade: 1.0))
        ruleSystem.add(GKRule(predicate: NSPredicate(format: "$mobCount.intValue == 0"), assertingFact: "allMobsDestroyed" as NSObject, grade: 1.0))
    }
    
    func setup(scene: GameScene) {
        
        if let node = getReadyNode {
            
            scene.addChild(node)
            node.run(.sequence([SKAction.customAction(withDuration: 0) { node, _ in node.reset() }, SKAction.wait(forDuration: 1.0), SKAction(named: "ZoomFadeOut")!, SKAction.removeFromParent()]))
            node.isPaused = false
        }
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        
        stateMachine.update(deltaTime: deltaTime)
        
        ruleSystem.reset()
        ruleSystem.state["mobCount"] = scene.mobSpawner.activeCount
        ruleSystem.evaluate()
        
        // TODO: Move this elsewhere
        if ruleSystem.grade(forFact: "mobCountIsLow" as NSObject) >= 1.0 {
            
            scene.spawnTicker = scene.spawnTicker?.tick(deltaTime: deltaTime) {
                
                func wave(s: String) {
                    
                    let f: (CGPoint) -> Void = { p in print("\(s) \(p)") }
                    PointPattern.circle(divs: 4).trace(size: 1, with: f)
                }

                scene.spawn(name: "Ship")
                scene.spawn(name: "Ship")
                scene.spawn(name: "Mob")
                scene.spawn(name: "Mob")
                scene.spawn(name: "AniMob")
                scene.spawn(name: "AniMob")
                scene.spawn(name: "Robot")
                scene.spawn(name: "Robot")
            }
        }
    }
    
    func postamble(scene: GameScene) {
        
        scene.addScore(score: 31337)
        
        if let node = postambleNode {
            
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
        
        print("Tearing down level in \(scene)")
    }
}

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
