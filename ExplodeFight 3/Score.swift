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
    
    func add(add: Int) -> Score { return Score(dis: dis, acc: dis + add) }
    
    func tick() -> Score {
        
        let add = acc > 2 ? acc / 2 : acc
        
        return Score(dis: dis + add, acc: acc - add)
    }
}
