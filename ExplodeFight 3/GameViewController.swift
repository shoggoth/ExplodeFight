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

class GameViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let view = self.view as? SKView else { return }
        
        // Set up the view
        view.preferredFramesPerSecond = 120
        view.ignoresSiblingOrder = true

        // Register for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(updateActiveStatus(withNotification:)), name: UIApplication.didBecomeActiveNotification,  object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateActiveStatus(withNotification:)), name: UIApplication.willResignActiveNotification, object: nil)
        
        #if DEBUG
        view.showsFPS = true
        view.showsNodeCount = true
        
        view.load(sceneWithFileName: "GameScene")
        //sceneManager.load(sceneWithFileName: "PlayScene")
        #else
        //sceneManager.load(sceneWithFileName: "SplashScene")
        #endif
    }

    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }

    func viewDidLoad_() {
        
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }

    // MARK: Notification
    
    @objc func updateActiveStatus(withNotification notification: NSNotification) {
        
        print("TODO: Handle these with pausing in the current scene = \(notification)")
    }
    
    // MARK: View behaviour
    
    override var shouldAutorotate: Bool { return true }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return UIDevice.current.userInterfaceIdiom == .phone ? .allButUpsideDown : .all }

    override var prefersStatusBarHidden: Bool { return true }
}
