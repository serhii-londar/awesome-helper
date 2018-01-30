//
//	RepositoryRootClass.swift
//
//	Create by Serhii Londar on 29/1/2018
//	Copyright © 2018 Techmagic. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import FileKit

struct Repositories : Codable {
    static let filename = "repositories.json"
    static let folder = "Repositories"
    
    var repositories : [Repository]?
    
    enum CodingKeys: String, CodingKey {
        case repositories = "repositories"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        repositories = try values.decodeIfPresent([Repository].self, forKey: .repositories)
    }
    
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encodeIfPresent(repositories, forKey: .repositories)
    }
}

extension Repositories {
    init() {
        self.repositories = [Repository]()
        try? self.save()
    }
}

extension Repositories {
    mutating func add(_ repository: Repository) throws {
        self.repositories?.append(repository)
        try self.save()
    }
    
    mutating func remove(_ repository: Repository) throws {
        if let index = repositories?.index(where: { (repo) -> Bool in
            return repository.name == repo.name && repository.owner == repository.owner && repository.url == repo.url && repository.localUrl == repo.localUrl
        }) {
            repositories?.remove(at: index)
        }
        try self.save()
    }
    
    static func load() throws -> Repositories  {
        let filePath = Path.userDocuments + Repositories.folder + Repositories.filename
        let file = TextFile(path: filePath)
        if file.exists == false {
            try file.create()
        }
        let data = try Data(contentsOf: filePath.url)
        return try JSONDecoder().decode(Repositories.self, from: data)
    }
    
    func save() throws {
        let path = Path.userDocuments + Repositories.folder
        if path.exists == false {
            try path.createDirectory()
        }
        let filePath = Path.userDocuments + Repositories.folder + Repositories.filename
        let file = TextFile(path: filePath)
        if file.exists == false {
            try file.create()
        }
        let data = try JSONEncoder().encode(self)
        try data.write(to: filePath.url)
    }
}
