//
//  Classess.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 2/3/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation
import FireRecord

class Repository: FireRecord {
    var name : String?
    var owner : String?
    var url : String?
    var queries: [String] = [String]()
    var reviewedRepositories: [String] = [String]()
}

class Query: FireRecord {
    var query: String?
    var repository: String?
}


class ReviewedRepository: FireRecord {
    var name : String?
    var owner : String?
    var url : String?
    var aproved : Bool?
    var repository: String?
}
