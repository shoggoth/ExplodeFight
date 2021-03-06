//
//  RulesComponent.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 18/12/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit

class RulesComponent: GKComponent {
    
    var updateCount = 0

    let ruleSystem: GKRuleSystem = GKRuleSystem()
    var ruleSystemUpdateInterval: TimeInterval = 1.0
    
    private var timeSinceLastRuleSystemUpdate: TimeInterval = 0.0
    
    override func update(deltaTime delta: TimeInterval) {
        
        timeSinceLastRuleSystemUpdate += delta
        if timeSinceLastRuleSystemUpdate < ruleSystemUpdateInterval { return }
        timeSinceLastRuleSystemUpdate -= ruleSystemUpdateInterval
        
        updateCount += 1
        
        ruleSystem.reset()
        ruleSystem.state["updateCount"] = updateCount
        ruleSystem.evaluate()
        
        if ruleSystem.grade(forFact: "updateCountIsLow" as NSObject) > 0.5 {
            
            print("State \(ruleSystem.state)")
            print("Facts \(ruleSystem.facts) \(ruleSystem.grade(forFact: "updateCountIsLow" as NSObject))")
        }
    }
    
    override class var supportsSecureCoding: Bool { return true }
}

// MARK: - TODO: Temp -

class FuzzyUpdateRule: GKRule {
    
    let fact: String
    var count: Int!
    
    // MARK: Initializers
    
    init(fact: String) {
        
        self.fact = fact
        
        super.init()
        
        // Set the salience so that 'fuzzy' rules will evaluate first.
        salience = Int.max
    }
    
    func grade() -> Float { return 0.0 }
    
    // MARK: GKRule Overrides
    
    override func evaluatePredicate(in system: GKRuleSystem) -> Bool {
        
        count = system.state["updateCount"] as? Int
        
        return grade() >= 0.0;
    }
}

class UpdateCountLowRule: FuzzyUpdateRule {
    
    // MARK: Initializers
    
    init() { super.init(fact: "updateCountLow") }
    
    // MARK: Properties
    
    override func grade() -> Float {
        
        return Float(count) * 0.1
    }
}
