//
//  Configuration.swift
//  ExplodeFight 3
//
//  Created by Richard Henry on 14/01/2021.
//  Copyright © 2021 Dogstar Industries Ltd. All rights reserved.
//

import Foundation

struct Configuration: Decodable {
    
    let infoString: String
    
    static func parse(fromPList name: String) -> Configuration {
        
        let url = Bundle.main.url(forResource: name, withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        
        return try! decoder.decode(Configuration.self, from: data)
    }
}

// MARK: -

struct Defaults {
    
    // Hard coded
    static let splashTiming = (nextPhaseTime: 1.5, crossFadeDuration: 0.5)
    
    static let serverURL = { Bundle.main.object(forInfoDictionaryKey: "SERVER_URL") as! String }()
    static let webAppEndpoint = { "\(serverURL)/app/unknown" }()
    
    // User defaults
    @UserDefault("UserToken", defaultValue: "G4R9leqQP2wmE4jxWGDXnzDpPGUNXo") static var userToken: String
    @UserDefault("TutorialHasBeenSeen", defaultValue: false) static var tutorialHasBeenSeen: Bool
}

// MARK: -

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

