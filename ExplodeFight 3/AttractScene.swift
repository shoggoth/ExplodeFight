//
//  AttractScene.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 15/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons

class AttractScene : BaseSKScene {
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // TODO: Could an SKAction be used to make this transition?
        // DispatchQueue.main.asyncAfter(deadline: .now() + timeUntilNextPhase) { self.view?.load(sceneWithFileName: GameViewController.config.initialSceneName, transition: transition) }
    }
    
    override func update(delta: TimeInterval) {
        
        super.update(delta: delta)
    }
}
