//
//  Global.swift
//  EF3
//
//  Created by Richard Henry on 10/05/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit

struct Global {
    
    static var soundManager = SoundManager(soundActions: ["Explode" : SKAction.playSoundFileNamed("Explode.caf", waitForCompletion: false)])
    static var explodeShader = ExplodeShader(shaderName: "explode.fsh")
    static var particleExploder = ParticleExploder(fileName: "Explode0.sks")
    static var warpExploder = WarpExploder(shaderName: "explode.fsh")
}
