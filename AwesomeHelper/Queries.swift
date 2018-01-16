//
//  Queries.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/13/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation
import FileKit

class Queries {
    var queries: [Query] = [Query]()
    let queriesFolderName = "queries"
    let queriesFileName = "queries.txt"
    let repositoryName: String
    var fileContent: String
    var queriesFile: TextFile
    
    init(repositoryName: String) throws {
        self.repositoryName = repositoryName
        
        let queriesPath = Path.userDocuments + self.repositoryName + queriesFolderName
        if queriesPath.exists == false {
            try queriesPath.createDirectory()
        }
        let filePath = queriesPath + queriesFileName
        queriesFile = TextFile(path: filePath)
        if queriesFile.exists == false {
            try queriesFile.create()
        }
        self.fileContent = try queriesFile.read()
        
        let queriesStrings: [String] = self.fileContent.components(separatedBy: "\n")
        for queriesString in queriesStrings {
            self.queries.append(try Query(query: queriesString, repositoryName: self.repositoryName))
        }
    }
    
    func addQuery(_ queryString: String) throws -> Query {
        self.fileContent.append(queryString + "\n")
        try queriesFile.write(self.fileContent, atomically: true)
        let query = try Query(query: queryString, repositoryName: self.repositoryName)
        self.queries.append(query)
        return query
    }
    
    func removeQuery(_ queryString: String) throws {
        if let range = self.fileContent.range(of: queryString) {
            self.fileContent.removeSubrange(range)
        }
        
        if let index = self.queries.index(where: { (q) -> Bool in
            return q.query == queryString
        }) {
            self.queries.remove(at: index)
        }
        try queriesFile.write(self.fileContent, atomically: true)
        let query = try Query(query: queryString, repositoryName: self.repositoryName)
        self.queries.append(query)
    }
    
    func getQuery(_ queryString: String) -> Query? {
        if let index = self.queries.index(where: { (q) -> Bool in
            return q.query == queryString
        }) {
            return self.queries[index]
        }
        return nil
    }
    
    func contains(_ queryString: String) -> Bool {
        if self.fileContent.range(of: queryString) != nil {
            return true
        }
        return false
    }
}
