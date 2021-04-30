//
//  Level.swift
//  EF3
//
//  Created by Richard Henry on 12/03/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

struct Level {
    
    private let ruleSystem: GKRuleSystem = GKRuleSystem()

    init() {
        
        // Setup level rules
        ruleSystem.add(GKRule(predicate: NSPredicate(format: "$mobCount.intValue < 10"), assertingFact: "mobCountIsLow" as NSObject, grade: 1.0))
        ruleSystem.add(GKRule(predicate: NSPredicate(format: "$mobCount.intValue == 0"), assertingFact: "allMobsDestroyed" as NSObject, grade: 1.0))
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        
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
}
