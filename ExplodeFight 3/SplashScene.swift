//
//  SplashScene.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 03/12/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons

class SplashScene : BaseSKScene {
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        // TODO: Change these to use the Configuration
        let timeUntilNextPhase = Defaults.splashTiming.nextPhaseTime
        let transition = SKTransition.crossFade(withDuration: Defaults.splashTiming.crossFadeDuration)
        transition.pausesIncomingScene = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeUntilNextPhase) {
            
            self.view?.load(sceneWithFileName: "GameScene", transition: transition)
        }
    }
    
    override func update(delta: TimeInterval) {
        
        super.update(delta: delta)
    }
}

