//
//  GameViewController.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 23/11/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
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
        
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
        
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
        
        (self.view as? SKView)?.scene?.isPaused = notification.name == UIApplication.didEnterBackgroundNotification
    }
    
    // MARK: Overrides
    
    override var shouldAutorotate: Bool { return true }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .landscape }

    override var prefersStatusBarHidden: Bool { return true }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { return .all }
}

extension GameViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        
        gameCenterViewController.dismiss(animated: true)
    }
    
    func authenticateLocalPlayer() {
        
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = { vc, error in
            
            if let vc = vc { self.present(vc, animated: true) }
            
            if localPlayer.isAuthenticated {
                
                print("Auth \(localPlayer.alias) \(localPlayer.displayName)")

                localPlayer.loadDefaultLeaderboardIdentifier() { boardIdentifier, error in
                    
                    if let id = boardIdentifier {
                        
                        let score = GKScore(leaderboardIdentifier: id)
                        
                        score.value = 100
                        GKScore.report([score]) { error in print("Score submit \(error)") }
                    }

                    GKLeaderboard.loadLeaderboards { leaderboards, error in
                        
                        leaderboards?.forEach { board in
                            
                            print("Found a board \(board.identifier) scores \(board.scores)")
                        }
                    }
                }
            }
        }
    }
}
