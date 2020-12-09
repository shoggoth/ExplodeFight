//
//  SplashScene.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 03/12/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import SpriteKit
import SpriteKitAddons

class SplashScene : BaseSKScene {
    
    override func didMove(to view: SKView) {
        
        super.didMove(to: view)
        
        let timeUntilNextPhase = Configuration.splashTiming.nextPhaseTime
        let transition = SKTransition.crossFade(withDuration: Configuration.splashTiming.crossFadeDuration)
        transition.pausesIncomingScene = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeUntilNextPhase) {
            
            self.view?.load(sceneWithFileName: "GameScene", transition: transition)
        }
    }
    
    override func update(delta: TimeInterval) {
        
        super.update(delta: delta)
    }
}

// MARK: - Configuration

struct Configuration {
    
    // Hard coded
    static let splashTiming = (nextPhaseTime: 1.5, crossFadeDuration: 0.5)
    
    static let serverURL = { Bundle.main.object(forInfoDictionaryKey: "SERVER_URL") as! String }()
    static let webAppEndpoint = { "\(serverURL)/app/unknown" }()
    
    // User defaults
    @UserDefault("UserToken", defaultValue: "G4R9leqQP2wmE4jxWGDXnzDpPGUNXo") static var userToken: String
    @UserDefault("TutorialHasBeenSeen", defaultValue: false) static var tutorialHasBeenSeen: Bool
}

// MARK: - User defaults

@propertyWrapper struct UserDefault<T> {
    
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}

