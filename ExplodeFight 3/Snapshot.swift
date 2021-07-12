//
//  Snapshot.swift
//  EF3
//
//  Created by Richard Henry on 12/07/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit
import SpriteKitAddons

class LevelSnapshot {
    
    var mobEntities = [GKEntity]()
    
    var mobsKilled: Int = 0
    
    func update(scene: GameScene, mobSpawner: SceneSpawner) {
        
        var count = 0
        var ships = 0
        var nearp = 0
        
        mobEntities.removeAll()
        
        mobSpawner.iterateEntities { e in
            
            mobEntities.append(e)
            count += 1
            if e.spriteComponent?.node.name == "Ship" { ships += 1 }
            
            if let ppos = scene.playerEntity?.spriteComponent?.node.position, let epos = e.spriteComponent?.node.position {
                
                if abs(hypotf(Float(epos.x - ppos.x), Float(epos.y - ppos.y))) < 64 { nearp += 1 }
            }
        }
        
        print(nearp)
        
        //let bum = mobs.filter { $0.agent?.position.y ?? 0 >= 350 }
        //print("entity = \(count) ships = \(ships) mobs = \(bum.count) near = \(nearp)")
    }
}

extension StateDrivenLevel {
    
}
