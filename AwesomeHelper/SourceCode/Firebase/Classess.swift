//
//  Classess.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 2/3/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation
import Salada

class Repository: Salada.Object {
    @objc dynamic var name : String?
    @objc dynamic var owner : String?
    @objc dynamic var url : String?
    var queries: Relation<Query> = []
    var ignoredRepos: Relation<ReviewedRepository> = []
    var aprovedRepos: Relation<ReviewedRepository> = []
    
    class var _name: String {
        return "repositories"
    }
}

class Query: Salada.Object {
    @objc dynamic var query: String?
    var repository: Repository?
}


class ReviewedRepository: Salada.Object {
    @objc dynamic var name : String?
    @objc dynamic var owner : String?
    @objc dynamic var url : String?
    
}
