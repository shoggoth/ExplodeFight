//
//  Score.swift
//  EF3
//
//  Created by Richard Henry on 21/04/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit

struct Score {
    
    var current : Int { dis + acc }
    
    let dis: Int
    let acc: Int
    
    func updateLabel(label: SKLabelNode) -> Score {
        
        let newScore = Score(dis: 10, acc: 20)
        
        return newScore
    }
}
