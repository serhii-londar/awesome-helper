//
//  Queries.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 2/1/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation
import RealmSwift

class Query: Object {
    @objc dynamic var query: String = ""
    var repository: Repository = Repository()
}

class Repository: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var owner : String = ""
    @objc dynamic var url : String = ""
    var queries = List<Query>()
    var ignoredRepos = List<ReviewedRepository>()
    var aprovedRepos = List<ReviewedRepository>()
}

class ReviewedRepository: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var owner : String = ""
    @objc dynamic var url : String = ""
}
