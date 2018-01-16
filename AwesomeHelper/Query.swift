//
//  Query.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/13/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation
import FileKit

class Query {
    var query: String
    var repositoryName: String
    let queriesFolderName = "queries"
    var queriesPath: Path
    var textFile: TextFile
    var fileContent: String

    init(query: String, repositoryName: String) throws {
        self.query = query
        self.repositoryName = repositoryName
        self.queriesPath = Path.userDocuments + self.repositoryName + queriesFolderName
        if queriesPath.exists == false {
            try queriesPath.createDirectory()
        }
        let fileName = query + ".txt"
        textFile = TextFile(path: queriesPath + fileName)
        if textFile.exists == false {
            try textFile.create()
        }
        self.fileContent = try textFile.read()
    }
    
    func append(_ string: String) throws {
        self.fileContent.append(string + "\n")
        try self.textFile.write(self.fileContent, atomically: true)
    }
    
    func contains(_ string: String) -> Bool {
        return self.fileContent.contains(string)
    }
}
