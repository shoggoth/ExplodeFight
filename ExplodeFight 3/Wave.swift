//
//  Wave.swift
//  EF3
//
//  Created by Richard Henry on 07/05/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit

enum PointPattern {
    
    case rectangle(w: Int, h: Int)
    case circle(divs: Int)
    
    func trace(size: CGFloat, with:(CGPoint) -> Void) {
        
        switch self {
        
        case let .rectangle(w, h):
            
            let off = size * 0.5
            (0..<h).forEach { y in (0..<w).forEach { x in with(CGPoint(x: CGFloat(x) * size - off, y: CGFloat(y) * size - off)) }}
            
        case let .circle(divs):
            
            let inc = (.pi * 2.0) / Double(divs)
            
            (0..<divs).forEach { d in
                
                let angle = Double(d) * inc
                with(CGPoint(x: CGFloat(sin(angle)) * size, y: CGFloat(cos(angle)) * size)) }
        }
    }
}
