//
//  ContactComponent.swift
//  EF3
//
//  Created by Richard Henry on 27/05/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import GameplayKit

class ContactComponent: GKComponent, NodeContact {
    
    let beginFunc: ((SKNode) -> ())?
    
    init(beginFunc: ((SKNode) -> ())? = nil) {
        
        self.beginFunc = beginFunc
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: Contact handling
    
    func contactWithNodeDidBegin(_ node: SKNode) {
        
        //print("MC Contact begins: \(self) with \(node)")
        beginFunc?(node)
    }
    
    func contactWithNodeDidEnd(_ node: SKNode) {
        
        //print("MC Contact ends: \(self) with \(node)")
    }
}

// MARK: -

protocol NodeContact {

    func contactWithNodeDidBegin(_ node: SKNode)
    
    func contactWithNodeDidEnd(_ node: SKNode)
}

extension SKNode: NodeContact {
    
    func contactWithNodeDidBegin(_ node: SKNode) {
        
        entity?.component(ofType: ContactComponent.self)?.contactWithNodeDidBegin(node)
    }
    
    func contactWithNodeDidEnd(_ node: SKNode) {
        
        entity?.component(ofType: ContactComponent.self)?.contactWithNodeDidEnd(node)
    }
}


