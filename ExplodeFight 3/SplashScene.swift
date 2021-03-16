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
        
        let timeUntilNextPhase = 3.0
        let transition = SKTransition.doorway(withDuration: 2.3)
        transition.pausesIncomingScene = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeUntilNextPhase) {
            
            self.view?.load(sceneWithFileName: "GameScene", transition: transition)
        }
    }
}
