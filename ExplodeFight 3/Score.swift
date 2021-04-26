//
//  Score.swift
//  EF3
//
//  Created by Richard Henry on 21/04/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import GameKit

struct Score {
    
    var current : Int64 { dis + acc }
    
    let dis: Int64
    let acc: Int64
    
    func add(add: Int64) -> Score { return Score(dis: dis, acc: acc + add) }
    
    func tick() -> Score {
        
        let add = acc > 2 ? acc / 2 : acc
        
        return Score(dis: dis + add, acc: acc - add)
    }
}

// MARK: -

struct ScoreManager {
    
    static var localPlayer = GKLocalPlayer.local
    
    static func loadHiScores(completion:((String, [GKScore]?) -> Void)? = nil) {

        if localPlayer.isAuthenticated {
            
            localPlayer.loadDefaultLeaderboardIdentifier() { boardIdentifier, error in
                
                if let id = boardIdentifier {
                    
                    let board = GKLeaderboard()
                    board.identifier = id
                    board.loadScores() { scores, error in
                        
                        if let error = error { NSLog("Score load error: \(error)") } else { completion?(id, scores) }
                    }
                }
            }
        }
    }
    
    static func submitHiScore(boardIdentifier: String, score: Score) {
        
        let gks = GKScore(leaderboardIdentifier: boardIdentifier)
        
        gks.value = score.current
        GKScore.report([gks]) { error in if let error = error { NSLog("Score submit error: \(error)")} }
    }
}
