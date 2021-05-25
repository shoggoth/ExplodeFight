//
//  MobComponent.swift
//  EF3
//
//  Created by Richard Henry on 19/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

class MobComponent: GKComponent {
    
    let stateMachine: GKStateMachine
    
    init(states: [GKState]) {
        
        stateMachine = GKStateMachine(states: states)
        if let firstState = states.first { stateMachine.enter(type(of: firstState)) }
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)

        stateMachine.update(deltaTime: deltaTime)
    }
}

// MARK: - Lifecycle states -

class LiveState: GKState {
    
    private let node: SKSpriteNode
    private var countdownTimer: CountdownTimer?
    private var warpTimer: PeriodicTimer?

    init(warpNode: SKSpriteNode) {
        
        node = warpNode
        
        let warpGeometryGridNoWarp = SKWarpGeometryGrid(columns: 2, rows: 2)
        
        let sourcePositions: [SIMD2<Float>] = [
            SIMD2<Float>(0, 1),   SIMD2<Float>(0.5, 1),   SIMD2<Float>(1, 1),
            SIMD2<Float>(0, 0.5), SIMD2<Float>(0.5, 0.5), SIMD2<Float>(1, 0.5),
            SIMD2<Float>(0, 0),   SIMD2<Float>(0.5, 0),   SIMD2<Float>(1, 0)
        ]
        let destinationPositions: [SIMD2<Float>] = [
            SIMD2<Float>(-0.25, 1.5), SIMD2<Float>(0.5, 1.75), SIMD2<Float>(1.25, 1.5),
            SIMD2<Float>(0.25, 0.5),   SIMD2<Float>(0.5, 0.5),   SIMD2<Float>(0.75, 0.5),
            SIMD2<Float>(-0.25, -0.5),  SIMD2<Float>(0.5, -0.75),  SIMD2<Float>(1.25, -0.5)
        ]
        let warpGeometryGrid = SKWarpGeometryGrid(columns: 2, rows: 2, sourcePositions: sourcePositions, destinationPositions: sourcePositions)
        
        node.warpGeometry = warpGeometryGridNoWarp
        node.run(SKAction.warp(to: warpGeometryGrid, duration: 2.0)!)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is DieState.Type || stateClass is ExplodeState.Type }
    
    override func didEnter(from previousState: GKState?) {
        
        countdownTimer = CountdownTimer(countDownTime: 60.0)
        warpTimer = PeriodicTimer(tickInterval: 2)
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        countdownTimer = countdownTimer?.tick(deltaTime: deltaTime) { stateMachine?.enter(ExplodeState.self) }
        warpTimer = warpTimer?.tick(deltaTime: deltaTime) { print("Warp \(node)") }
    }
}

class ExplodeState: GKState {
    
    private var explodeFunc: (() -> Void)?
    private var countdownTimer: CountdownTimer?
    
    init(completion: (() -> Void)? = nil) { explodeFunc = completion }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is DieState.Type }
    
    override func didEnter(from previousState: GKState?) {
        
        countdownTimer = CountdownTimer(countDownTime: 0.2)
        
        explodeFunc?()
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        countdownTimer = countdownTimer?.tick(deltaTime: deltaTime) { stateMachine?.enter(DieState.self) }
    }
}

class DieState: GKState {
    
    private var dieFunc: (() -> Void)?
    
    init(completion: (() -> Void)? = nil) { dieFunc = completion }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is LiveState.Type }
    
    override func didEnter(from previousState: GKState?) {
        
        dieFunc?()
    }
}
