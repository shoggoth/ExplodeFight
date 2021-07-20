//
//  GameViewController.swift
//  ExplodeFight tvOS
//
//  Created by Richard Henry on 20/07/2021.
//

import UIKit
import SpriteKit
import SpriteKitAddons
import GameplayKit
import GameKit

class GameViewController: UIViewController {

    static let config = Configuration.parse(fromPList: "Game")

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let view = self.view as? SKView else { return }
        
        // Set up the view
        view.preferredFramesPerSecond = 120
        view.ignoresSiblingOrder = true

        // Register for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(updateActiveStatus(withNotification:)), name: UIApplication.didBecomeActiveNotification,  object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateActiveStatus(withNotification:)), name: UIApplication.willResignActiveNotification, object: nil)
        
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

    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Notification
    
    @objc func updateActiveStatus(withNotification notification: NSNotification) {
        
        (self.view as? SKView)?.isPaused = notification.name == UIApplication.didEnterBackgroundNotification
    }
}

extension GameViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismiss(animated: true)
    }
    
    func authenticateLocalPlayer() {
        
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            
            if let vc = vc { self.present(vc, animated: true) }
            
            // TODO: This is temp
            ScoreManager.loadChieves()
        }
    }
}
