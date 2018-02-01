//
//  DB.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/31/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    static var `default`: Realm {
        return try! Realm()
    }
    
    static func initialize() {
        var config = Realm.Configuration()
        
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("default.realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    
    func setDefaultRealmForUser(username: String) {
        var config = Realm.Configuration()
        
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(username).realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
}
