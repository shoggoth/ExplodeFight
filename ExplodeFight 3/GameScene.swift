//
//  GameScene.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 23/11/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons
import GameControls

class GameScene: BaseSKScene {
    
    override var requiredScaleMode: SKSceneScaleMode { .aspectFit }
    
    let joystick = TouchJoystick()
    
    override func didMove(to view: SKView) {
        
        setupJoystick(joystick)
    }
    
    override func update(delta: TimeInterval) {
        
        super.update(delta: delta)
    }
}
