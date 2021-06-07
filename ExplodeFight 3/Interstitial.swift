//
//  Interstitial.swift
//  EF3
//
//  Created by Richard Henry on 01/06/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit

struct Interstitial {
    
    private static var interRef = { SKReferenceNode(fileNamed: "Interstitial") }()
    static var getReadyNode = interRef?.orphanedChildNode(withName: "//GetReady/Root")
    static var gameOverNode = interRef?.orphanedChildNode(withName: "//GameOver/Root")
    static var bonusNode = interRef?.orphanedChildNode(withName: "//Bonus/Root")
}
