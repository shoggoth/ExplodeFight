//
//  Interstitial.swift
//  EF3
//
//  Created by Richard Henry on 01/06/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit

struct Interstitial {
    
    private static let interScene = { SKScene(fileNamed: "Interstitial") }()
    static let getReadyNode = { interScene?.orphanedChildNode(withName: "GetReady/Root") }()
    static let postambleNode = { interScene?.orphanedChildNode(withName: "Bonus/Root") }()
    static let gameOverNode = { interScene?.orphanedChildNode(withName: "GameOver/Root") }()
}
