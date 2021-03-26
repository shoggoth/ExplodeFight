//
//  SoundManager.swift
//  EF3
//
//  Created by Richard Henry on 26/03/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit

struct SoundManager {
    
    var playNode: SKNode?
    let soundActions: [String : SKAction]
    
    func playSound(name: String) {
        
        guard let action = soundActions[name], let node = playNode else { return }
        
        node.run(action)
    }
}
