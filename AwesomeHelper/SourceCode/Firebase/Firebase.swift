//
//  Classess.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 2/3/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation
import FirebaseSDK

class Repositories: ObjectCollection<Repository> { }

@objcMembers class Repository: Object {
    var name : String = ""
    var owner : String = ""
    var url : String = ""
    var queries: ObjectsRelation<Query>!
    var reviewedRepositories: ObjectsRelation<ReviewedRepository>!
	
    override func initialize() {
        self.queries = ObjectsRelation<Query>(parent: self)
        self.reviewedRepositories = ObjectsRelation<ReviewedRepository>(parent: self)
    }
	
    override func setValue(_ value: Any?, forKey key: String) {
		let dict = value as? [AnyHashable : Any] ?? [:]
        if key == "queries" {
			self.queries?.update(dict: dict)
        } else if key == "reviewedRepositories" {
            self.reviewedRepositories?.update(dict: dict)
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func value(forKey key: String) -> Any? {
        if key == "queries" {
            return self.queries
        } else if key == "reviewedRepositories" {
            return self.reviewedRepositories
        }
        return super.value(forKey: key)
    }
}

@objcMembers class Query: Object {
    var query: String = ""
    var repository: ObjectsRelation<Repository>!
	
    override func initialize() {
        self.repository = ObjectsRelation<Repository>(parent: self)
    }
	
    override func setValue(_ value: Any?, forKey key: String) {
		let dict = value as? [AnyHashable : Any] ?? [:]
        if key == "repository" {
			self.repository?.update(dict: dict)
		} else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func value(forKey key: String) -> Any? {
        if key == "repository" {
            return self.repository
		} else {
			return super.value(forKey: key)
		}
    }
}


@objcMembers class ReviewedRepository: Object {
    var name : String = ""
    var owner : String = ""
    var url : String = ""
    var aproved : Bool = false
    var repository: ObjectsRelation<Repository>!
	
    override func initialize() {
        self.repository = ObjectsRelation<Repository>(parent: self)
    }
	
    override func setValue(_ value: Any?, forKey key: String) {
		let dict = value as? [AnyHashable : Any] ?? [:]
        if key == "repository" {
			self.repository?.update(dict: dict)
		} else {
            super.setValue(value, forKey: key)
        }
    }
    
    override func value(forKey key: String) -> Any? {
        if key == "repository" {
            return self.repository
		} else {
			return super.value(forKey: key)
		}
    }
}
