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
    func teardown(scene: GameScene)
}

private let interstitialScene = SKScene(fileNamed: "Interstitial")
private let getReadyNode = { interstitialScene?.orphanedChildNode(withName: "GetReady/Root") }()
private let getReadyAction = SKAction.sequence([SKAction.customAction(withDuration: 0) { node, _ in node.reset() }, SKAction.wait(forDuration: 1.0), SKAction(named: "ZoomFadeOut")!, SKAction.removeFromParent()])

struct StateDrivenLevel: Level {
    
    let name: String
    
    private let stateMachine: GKStateMachine
    private let ruleSystem = GKRuleSystem()
    
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
            node.run(getReadyAction)
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
                
                scene.spawn(name: "Ship")
                scene.spawn(name: "Ship")
                scene.spawn(name: "Mob")
                scene.spawn(name: "Mob")
                scene.spawn(name: "Robot")
                scene.spawn(name: "Robot")
            }
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
    
    class CountState: CountdownState {
        
        init(completion: (() -> CountdownTimer?)? = nil) { super.init(enter: completion, exit: { stateMachine in stateMachine?.enter(EndedState.self) }) }
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is EndedState.Type }
    }
    
    class EndedState: GKState {
        
        private var endFunc: (() -> Void)?
        
        init(completion: (() -> Void)? = nil) { endFunc = completion }
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { false }
        
        override func didEnter(from previousState: GKState?) { endFunc?() }
    }
}
