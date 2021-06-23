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
    
    private lazy var vehicleSpawner = SceneSpawner(scene: SKScene(fileNamed: "Spawn")!)
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // Set up user control
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(spawn)))
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(clear)))

        // Set up scene physics
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    }
    
    @objc func spawn(_ tap: UITapGestureRecognizer) {
        
        spawnVehicle()
    }
    
    @objc func clear(_ tap: UITapGestureRecognizer) {
        
        if tap.state == .began { vehicleSpawner.kill(recycle: false) }
    }
    
    override func update(deltaTime: TimeInterval) {
        
        super.update(deltaTime: deltaTime)
        
        vehicleSpawner.update(deltaTime: deltaTime)
    }
    
    func spawnVehicle() {
        
        if let rootNode = vehicleSpawner.spawn(name: "Vehicle") {
            
            rootNode.position = CGPoint(x: CGFloat.random(in: -500...500), y: CGFloat.random(in: -300...300))
            rootNode.isPaused = false
            
            addChild(rootNode)
            
            let dpb = rootNode.childNode(withName: "Body")?.physicsBody
            let leftAxle = rootNode.childNodePositionInScene(name: "Body/AxleLeft", scene: self, defaultPhysicsBody: dpb)!
            let rightAxle = rootNode.childNodePositionInScene(name: "Body/AxleRight", scene: self, defaultPhysicsBody: dpb)!
            let leftWheel = rootNode.childNodePositionInScene(name: "WheelLeft", scene: self)!
            let rightWheel = rootNode.childNodePositionInScene(name: "WheelRight", scene: self)!
            
            let leftSpring = SKPhysicsJointSpring.joint(withBodyA: leftAxle.phys, bodyB: leftWheel.phys, anchorA: leftAxle.pos, anchorB: leftWheel.pos)
            leftSpring.frequency = 3
            leftSpring.damping = 0.2
            let rightSpring = SKPhysicsJointSpring.joint(withBodyA: rightAxle.phys, bodyB: rightWheel.phys, anchorA: rightAxle.pos, anchorB: rightWheel.pos)
            rightSpring.frequency = 3
            rightSpring.damping = 0.2

            self.physicsWorld.add(leftSpring)
            self.physicsWorld.add(rightSpring)
        }
    }
}

// MARK: - Spawn from Spawn.sks

extension SKNode {
    
    func childNodePositionInScene(name: String, scene: GameScene, defaultPhysicsBody: SKPhysicsBody? = nil) -> (node: SKNode, phys: SKPhysicsBody, pos: CGPoint)? {
        
        guard let child = childNode(withName: name), let pb = defaultPhysicsBody ?? child.physicsBody ?? self.physicsBody else { return nil }

        return (child, pb, convert(child.position, to: scene))
    }
}
