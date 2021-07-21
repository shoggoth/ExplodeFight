//
//  GameViewController.swift
//  ExplodeFight macOS
//
//  Created by Richard Henry on 20/07/2021.
//

import Cocoa
import SpriteKit
import SpriteKitAddons
import GameplayKit
import GameKit

class GameViewController: NSViewController {
    
    static let config = Configuration.parse(fromPList: "Game")

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let view = self.view as? SKView else { return }
        
        // Set up the view
        view.preferredFramesPerSecond = 120
        view.ignoresSiblingOrder = true
        
        // GameKit
        authenticateLocalPlayer()
        
        #if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsDrawCount = true
        
        view.load(sceneWithFileName: Self.config.initialSceneName)
        #else
        view.load(sceneWithFileName: "SplashScene")
        #endif
    }
}

extension GameViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismiss(true)
    }
    
    func authenticateLocalPlayer() {
        
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            
            //if let vc = vc { self.present(vc, .null }
            
            // TODO: This is temp
            ScoreManager.loadChieves()
        }
    }
}

