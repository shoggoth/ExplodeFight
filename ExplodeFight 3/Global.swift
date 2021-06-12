//
//  Global.swift
//  EF3
//
//  Created by Richard Henry on 10/05/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons

struct Global {
    
    static var soundManager = SoundManager(soundActions: ["Explode" : .playSoundFileNamed("Explode.caf", waitForCompletion: false)])
    static var explodeShader = ExplodeShader(shaderName: "explode.fsh")
    static var particleExploder = ParticleExploder(fileName: "Explode0.sks")
    static var scoreCharSet = LinearTexCharSet(texName: "5x5Charset", alphabet : " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,'?!/-")
}
