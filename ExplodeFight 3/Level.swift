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
        ruleSystem.add(GKRule(predicate: NSPredicate(format: "$activeMobCount.intValue < 100"), assertingFact: "activeMobCountIsLow" as NSObject, grade: 1.0))
        ruleSystem.add(GKRule(predicate: NSPredicate(format: "$activeMobCount.intValue == 0"), assertingFact: "allMobsDestroyed" as NSObject, grade: 1.0))
    }
    
    func setup(scene: GameScene) {
        
        if let node = Interstitial.getReadyNode {
            
            (node as? SKLabelNode)?.text = name
            
            node.reset()
            scene.interstitialRootNode.addChild(node)
            
            node.run(.sequence([.wait(forDuration: 2.3), SKAction(named: "ZoomFadeOut")!, .removeFromParent()]))
            node.isPaused = false
        }
    }
    
    func update(deltaTime: TimeInterval, scene: GameScene) {
        
        stateMachine.update(deltaTime: deltaTime)
        
        updateSnapShot(scene: scene)
        
        ruleSystem.reset()
        ruleSystem.state["activeMobCount"] = mobSpawner.activeCount
        ruleSystem.evaluate()
        
        mobSpawner.update(deltaTime: deltaTime)
        pickupSpawner.update(deltaTime: deltaTime)

        if ruleSystem.grade(forFact: "levelIsOver" as NSObjectProtocol) >= 1.0 { stateMachine.enter(BonusState.self) }
        
        tempSpawnUpdate(deltaTime: deltaTime, scene: scene)
    }
    
    func postamble(scene: GameScene) {
        
        scene.addScore(score: 3)
        
        if let node = Interstitial.bonusNode {

            node.reset()
            scene.interstitialRootNode.addChild(node)

            node.run(.sequence([.wait(forDuration: 3.0),
                                SKAction(named: "ZoomFadeOut")!,
                                .removeFromParent(),
                                .run { stateMachine.enter(EndedState.self) }]))
            node.isPaused = false
            
            if let tomRoot = node.childNode(withName: "SuccessLabel") { Bonus().countUpNodeBonus(root: tomRoot) }
        }
    }
    
    func teardown(scene: GameScene) {
        
        scene.interstitialRootNode.removeAllChildren()
        mobSpawner.kill()
        pickupSpawner.kill()
    }
}

// MARK: - SnapShotting

class LevelSnapshot {
    
    var mobEntities = [GKEntity]()
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
    
    class PlayState: CountdownState {
        
        init(completion: (() -> CountdownTimer?)? = nil) { super.init(enter: completion, exit: { stateMachine in stateMachine?.enter(BonusState.self) }) }
        
        override func isValidNextState(_ stateClass: AnyClass) -> Bool { stateClass is EndedState.Type || stateClass is BonusState.Type }
    }
    
    class BonusState: GKState {
        
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
                            }()

                            let entitySetup: (SKNode) -> GKEntity = { node in
                                
                                let mobEntity = GKEntity()
                                
                                mobEntity.addComponent(GKSKNodeComponent(node: node))
                                mobEntity.addComponent(GKAgent2D(node: node, maxSpeed: mobDesc.maxSpeed, maxAcceleration: 20, radius: 20, mass: Float(node.physicsBody?.mass ?? 1), behaviour: GKBehavior(goal: GKGoal(toWander: Float.random(in: -1.0 ... 1.0) * 600), weight: 100.0)))
                                mobEntity.addComponent(StateComponent(states: mobDesc.makeStates(node: node, scene: scene, spawner: spawner)))
                                mobEntity.addComponent(ContactComponent { _ in node.entity?.component(ofType: StateComponent.self)?.stateMachine.enter(MobState.ExplodeState.self) })
                                mobEntity.addComponent(AIComponent())
                                mobEntity.addComponent(makeRandomFireComponent)
                                
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
