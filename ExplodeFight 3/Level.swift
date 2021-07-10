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
    var levelNum: Int { get }
    var name: String { get }
    
    // Properties
    var ruleSystem: GKRuleSystem { get }
    var snapshot: LevelSnapshot { get }
    
    // Functionality
    func setup(scene: GameScene)
    func update(deltaTime: TimeInterval, scene: GameScene)
    func postamble(scene: GameScene)
    func teardown(scene: GameScene)
}

// MARK: -

struct StateDrivenLevel: Level {
    
    let levelNum: Int
    let name: String

    internal let ruleSystem = GKRuleSystem()
    internal let snapshot: LevelSnapshot = LevelSnapshot()
    private  let stateMachine: GKStateMachine
    
    private let mobSpawner = SceneSpawner(scene: SKScene(fileNamed: "Mobs")!)
    private let pickupSpawner = SceneSpawner(scene: SKScene(fileNamed: "Pickups")!)

    init(levelNum: Int, name: String, states: [GKState]) {
        
        self.levelNum = levelNum
        self.name = "Level \(levelNum) - \(name)"
        
        stateMachine = GKStateMachine(states: states)
        if let firstState = states.first { stateMachine.enter(type(of: firstState)) }
        
        // Setup level rules
        let spawnTemp = 100
        ruleSystem.add(GKRule(predicate: NSPredicate(format: "$activeMobCount.intValue < \(spawnTemp)"), assertingFact: "activeMobCountIsLow" as NSObject, grade: 1.0))
        ruleSystem.add(GKRule(predicate: NSPredicate(format: "$activeMobCount.intValue == 0"), assertingFact: "allMobsDestroyed" as NSObject, grade: 1.0))
        ruleSystem.add(GKRule(predicate: NSPredicate(format: "$mobsKilled.intValue >= \(spawnTemp)"), assertingFact: "levelIsOver" as NSObject, grade: 1.0))
    }
    
    func setup(scene: GameScene) {
        
        scene.interstitial.flashupNode(named: "GetReady")
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        
        stateMachine.update(deltaTime: deltaTime)
        
        updateSnapShot(scene: scene)
        
        ruleSystem.reset()
        ruleSystem.state["activeMobCount"] = mobSpawner.activeCount
        ruleSystem.state["activePickupCount"] = pickupSpawner.activeCount
        ruleSystem.state["mobsKilled"] = snapshot.mobsKilled
        ruleSystem.evaluate()
        
        mobSpawner.update(deltaTime: deltaTime)
        pickupSpawner.update(deltaTime: deltaTime)

        if ruleSystem.grade(forFact: "levelIsOver" as NSObjectProtocol) >= 1.0 { stateMachine.enter(BonusState.self) }
        if ruleSystem.grade(forFact: "levelIsOver" as NSObjectProtocol) >= 1.0 { print("LEVEL OVER!!!! TODO: Move this check to play state?") }

        tempSpawnUpdate(deltaTime: deltaTime, scene: scene)
    }
    
    func postamble(scene: GameScene) {
        
        scene.addScore(score: 3)
        
        scene.interstitial.flashupNode(named: "Bonus", action: .sequence([.unhide(), .wait(forDuration: 3.0), SKAction(named: "ZoomFadeOut")!, .hide(), .wait(forDuration: 1.0), .run { stateMachine.enter(EndedState.self)}]))
        scene.interstitial.countBonus()
    }
    
    func teardown(scene: GameScene) {
        
        scene.interstitial.hideNodes(names: ["GetReady", "GameOver", "Bonus"])
        mobSpawner.kill()
        pickupSpawner.kill()
    }
}

// MARK: - SnapShotting

class LevelSnapshot {
    
    var mobEntities = [GKEntity]()
    
    var mobsKilled: Int = 0
}

extension StateDrivenLevel {
    
    func updateSnapShot(scene: GameScene) {
        
        var count = 0
        var ships = 0
        var nearp = 0
        
        snapshot.mobEntities = []
        
        mobSpawner.iterateEntities { e in
            
            snapshot.mobEntities.append(e)
            count += 1
            if e.spriteComponent?.node.name == "Ship" { ships += 1 }
            
            if let ppos = scene.playerEntity?.spriteComponent?.node.position, let epos = e.spriteComponent?.node.position {
                
                
                if abs(hypotf(Float(epos.x - ppos.x), Float(epos.y - ppos.y))) < 64 { nearp += 1 }
            }
        }
        
        //let bum = mobs.filter { $0.agent?.position.y ?? 0 >= 350 }
        //print("entity = \(count) ships = \(ships) mobs = \(bum.count) near = \(nearp)")
    }
}

// MARK: - State

extension StateDrivenLevel {
    
    class PlayState: GKState {
        
        let scene: GameScene
        
        init(scene: GameScene) { self.scene = scene }
        
        override func didEnter(from previousState: GKState?) { scene.level?.teardown(scene: scene) }
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is EndedState.Type || stateClass is BonusState.Type }
    }
    
    class BonusState: GKState {
        
        let scene: GameScene
        
        init(scene: GameScene) { self.scene = scene }

        override func didEnter(from previousState: GKState?) { scene.level?.postamble(scene: scene) }
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is EndedState.Type }
    }
    
    class EndedState: GKState {
        
        let scene: GameScene
        
        init(scene: GameScene) { self.scene = scene }

        override func didEnter(from previousState: GKState?) { if scene.level != nil { scene.loadNextLevel() }}

        override func isValidNextState(_ stateClass: AnyClass) -> Bool { false }
    }
}

// MARK: - Temp TODO: Remove this

private var spawnTicker: PeriodicTimer? = PeriodicTimer(tickInterval: 1.7)

extension StateDrivenLevel {
    
    func tempSpawnUpdate(deltaTime: TimeInterval, scene: GameScene) {
        
        // TODO: Move this elsewhere
        if ruleSystem.grade(forFact: "activeMobCountIsLow" as NSObjectProtocol) >= 1.0 {
            
            spawnTicker = spawnTicker?.tick(deltaTime: deltaTime) {
                
                func wave(s: String) {
                    
                    let f: (CGPoint) -> Void = { p in
                        
                        if let spawner = mobSpawner.spawner(named: s) {

                            let mobDesc = Mob(name: s, maxSpeed: 600, pointValue: 100, position: p, rotation: CGVector(point: p).angle)
                            
                            let makeRandomFireComponent = { () -> FireComponent in
                                
                                let fc = FireComponent()
                                fc.weaponType = Int.random(in: 1...4)
                                fc.fireRate = Double.random(in: 0.5...5.0)
                                fc.fireVector = CGVector(angle: CGFloat.random(in: 0...pi * 2.0))
                                
                                return fc
                            }
                            
                            let entitySetup: (SKNode) -> GKEntity = { node in
                                
                                let mobEntity = GKEntity()
                                
                                mobEntity.addComponent(GKSKNodeComponent(node: node))
                                mobEntity.addComponent(GKAgent2D(node: node, maxSpeed: mobDesc.maxSpeed, maxAcceleration: 20, radius: 20, mass: Float(node.physicsBody?.mass ?? 1), behaviour: GKBehavior(goal: GKGoal(toWander: Float.random(in: -1.0 ... 1.0) * 600), weight: 100.0)))
                                mobEntity.addComponent(StateComponent(states: mobDesc.makeStates(node: node, scene: scene, spawner: spawner)))
                                mobEntity.addComponent(ContactComponent { _ in node.entity?.component(ofType: StateComponent.self)?.stateMachine.enter(MobState.ExplodeState.self) })
                                mobEntity.addComponent(AIComponent())
                                mobEntity.addComponent(makeRandomFireComponent())
                                
                                return mobEntity
                            }
                            
                            if let newNode = spawner.spawn(completion: { node in
                                
                                return entitySetup(node)
                            
                            }) { scene.mobRootNode.addChild(newNode) }
                        }
                    }
                    
                    PointPattern.circle(divs: 8).trace(size: 64, with: f)
                }

                wave(s: ["Ship", "Mob", "AniMob", "Robot"][Int.random(in: 0...3)])
                
                if let pickupNode = pickupSpawner.spawn(name: "Tomato", completion: { node in
                    
                    node.position = CGPoint(x: CGFloat.random(in: -200...200), y: CGFloat.random(in: -200...200))
                    let pickupEntity = GKEntity()
                    
                    pickupEntity.addComponent(ContactComponent { _ in
                        
                        scene.addScore(score: 999)
                        
                        pickupSpawner.kill(node: node)
                    })
                    
                    return pickupEntity
                    
                }) { scene.mobRootNode.addChild(pickupNode) }
            }
        }
    }
}
