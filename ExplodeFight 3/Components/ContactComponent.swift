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
    var endFunc: ((SKNode) -> ())? = nil

    init(beginFunc: ((SKNode) -> ())? = nil) {
        
        self.beginFunc = beginFunc
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: Contact handling
    
    func contactWithNodeDidBegin(_ node: SKNode) {
        
        beginFunc?(node)
    }
    
    func contactWithNodeDidEnd(_ node: SKNode) {
        
        endFunc?(node)
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


