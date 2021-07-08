//
//  Controller.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 07/07/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import Foundation
import GameController

class GameControllers: NSObject {
    
    override init() {
        
        super.init()
        
        // Wired controllers
        print(GCController.controllers())
        
        // Register for notifications of connections
        NotificationCenter.default.addObserver(self, selector: #selector(updateControllerStatus(withNotification:)), name: .GCControllerDidConnect,  object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateControllerStatus(withNotification:)), name: .GCControllerDidDisconnect, object: nil)
        
        GCController.startWirelessControllerDiscovery() { print("Starting discovery") }
    }

    deinit {
        
        GCController.stopWirelessControllerDiscovery()

        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Notification
    
    @objc func updateControllerStatus(withNotification notification: NSNotification) {
        
        guard let controller = notification.object as? GCController else { return }
        
        print("Name: \(controller.vendorName) Ext: \(controller.extendedGamepad?.leftThumbstick.xAxis)")
        
        controller.extendedGamepad?.valueChangedHandler = { pad, controller in print("Value changed \(pad) \(controller)") }
    }
}
