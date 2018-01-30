//
//  RepositoryHelper.swift
//  AwesomeHelper
//
//  Created by Serhii Londar on 1/13/18.
//  Copyright © 2018 slon. All rights reserved.
//

import Foundation
import ObjectiveGit

class RepositoryHelper {
    var queries: Queries
    var localRepositoryStringURL: String! = nil
    var localRepositoryURL: URL! = nil
    var repositoryName: String! = nil
    var remoteRepositoryStringURL: String! = nil
    var remoteRepositoryURL: URL! = nil
    
    var repository: GTRepository! = nil
    
    var readmeString: String {
        let readmeUrl = URL(string: self.localRepositoryStringURL + "/README.md")!
        let readmeData = try! Data(contentsOf: readmeUrl)
        let readmeString = String(data: readmeData, encoding: .utf8)
        return readmeString!
    }
    
    init(repositoryName: String, remoteRepositoryStringURL: String) throws {
        self.repositoryName = repositoryName
        self.remoteRepositoryStringURL = remoteRepositoryStringURL
        self.remoteRepositoryURL = URL(string: self.remoteRepositoryStringURL)!
        self.localRepositoryStringURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.absoluteString + repositoryName
        self.localRepositoryURL = URL(string: self.localRepositoryStringURL)!
        
        try FileManager.default.createDirectory(at: self.localRepositoryURL, withIntermediateDirectories: true, attributes: [:])
        
        do {
            self.repository = try GTRepository(url: URL(string: self.localRepositoryStringURL)!)
        } catch {
            self.repository = try GTRepository.clone(from: self.remoteRepositoryURL, toWorkingDirectory: self.localRepositoryURL, options: nil, transferProgressBlock: nil)
            
        }
        
        for remote in try self.repository.remoteNames() {
            let remote = try GTRemote(name: remote, in: self.repository)
            try self.repository.fetch(remote, withOptions: nil, progress: nil)
        }
        
        try queries = Queries(repositoryName: repositoryName)
    }

    func contains(_ string: String) -> Bool {
        return self.readmeString.contains(string)
    }
    
    func addQuery(_ query: String) throws -> Query {
        return try self.queries.addQuery(query)
    }
    
    func removeQuery(_ query: String) throws {
        try self.queries.removeQuery(query)
    }
    
    func getQuery(_ query: String) throws -> Query? {
        return self.queries.getQuery(query)
    }
    
    func commit() {
        let index: GTIndex = try! repository.index()
        let tree = try! index.writeTree(to: repository)
        let treeBuilder = try! GTTreeBuilder(tree: tree, repository: repository)
        try! repository.enumerateFileStatus(options: nil) { (status1, status2, success) in
            if status2?.status == .untracked {
                print("added")
                try! index.addFile((status2?.newFile?.path)!)
                
            }
        }
        
//        try! index.writeTree(to: repository)
        print("Error")
        let head: GTReference = try! repository.headReference()
        let headCommit: GTCommit = try! repository.lookUpObject(by: (head.targetOID)) as! GTCommit
        let committer = GTSignature(name: "Serhii Londar", email: "serhii.londar@gmail.com", time: Date())!
        let author: GTSignature = committer
//        let index: GTIndex = try! repository.index()

        let newCommit = try! repository.createCommit(with: index.writeTree(to: repository), message: "New Commit", author: author, committer: committer, parents: [headCommit], updatingReferenceNamed: "HEAD")
//
    }
    
//    func saveData(_ data: String) -> GTCommit? {
//        let blob = try? GTBlob(string: data, inRepository: repository)
//        let index: GTIndex? = try? repository.index()
//        try? index?.addData(blob.data, withPath: gitHistoryFileName)
//        let newCommit: GTCommit? = try? repository.createCommit(withTree: try? index?.writeTree(toRepository: repository), message: "Saving Data", author: author, committer: committer, parents: [headCommit], updatingReferenceNamed: "HEAD")
//        return newCommit
//    }
    
    func push() {
        
    }
}
