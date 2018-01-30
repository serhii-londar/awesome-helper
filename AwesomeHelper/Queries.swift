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
    var queries: [String] = [String]()
    
    let queriesFileName = "queries.txt"
    let ignoredReposFileName = "ignored.txt"
    let repositoryName: String
    var queriesFileContent: String
    var ignoredFileContent: String
    var queriesFile: TextFile
    var ignoredFile: TextFile
    
    init(repositoryName: String) throws {
        self.repositoryName = repositoryName
        
        let queriesPath = Path.userDocuments + "Repositories" + self.repositoryName
        if queriesPath.exists == false {
            try queriesPath.createDirectory()
        }
        let queriesFilePath = queriesPath + queriesFileName
        queriesFile = TextFile(path: queriesFilePath)
        if queriesFile.exists == false {
            try queriesFile.create()
        }
        self.queriesFileContent = try queriesFile.read()
        
        let queriesStrings: [String] = self.queriesFileContent.components(separatedBy: "\n")
        for queriesString in queriesStrings {
            self.queries.append(queriesString)
        }
        
        let ignoredFilePath = queriesPath + ignoredReposFileName
        ignoredFile = TextFile(path: ignoredFilePath)
        if ignoredFile.exists == false {
            try ignoredFile.create()
        }
        self.ignoredFileContent = try ignoredFile.read()
    }
    
    func addQuery(_ queryString: String) throws -> String {
        self.queriesFileContent.append(queryString + "\n")
        try queriesFile.write(self.queriesFileContent, atomically: true)
        return queryString
    }
    
    func removeQuery(_ queryString: String) throws {
        if let range = self.queriesFileContent.range(of: queryString) {
            self.queriesFileContent.removeSubrange(range)
        }
        if let index = self.queries.index(where: { (q) -> Bool in
            return q == queryString
        }) {
            self.queries.remove(at: index)
        }
        try queriesFile.write(self.queriesFileContent, atomically: true)
    }
    
    func contains(queryString: String) -> Bool {
        if self.queriesFileContent.range(of: queryString) != nil {
            return true
        }
        return false
    }
    
    
    //Work with ignored
    func append(repoUrl: String) throws {
        self.ignoredFileContent.append(repoUrl + "\n")
        try self.ignoredFile.write(self.ignoredFileContent, atomically: true)
    }
    
    func contains(repoUrl: String) -> Bool {
        return self.ignoredFileContent.contains(repoUrl)
    }
}
