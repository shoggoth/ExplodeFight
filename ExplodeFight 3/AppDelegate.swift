//
//  AppDelegate.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 23/11/2020.
//  Copyright © 2020 Dogstar Industries Ltd. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

@main class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var soundManager = SoundManager(soundActions: ["Explode" : .playSoundFileNamed("Explode.caf", waitForCompletion: false)])
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
}

