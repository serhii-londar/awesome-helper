//
//	Repository.swift
//
//	Create by Serhii Londar on 29/1/2018
//	Copyright © 2018 Techmagic. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import FileKit

struct Repository : Codable {
	let name : String?
    let owner : String?
	let url : String?
    let localUrl : String?
    
	enum CodingKeys: String, CodingKey {
		case name = "name"
		case url = "url"
        case owner = "owner"
        case localUrl = "localUrl"
	}
    
    init(name : String, owner : String, url : String) throws {
        self.owner = owner
        self.name = name
        self.url = url
        let path = Path.userDocuments + "Repositories" + name
        try path.createDirectory()
        self.localUrl = path.rawValue
    }
    
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		url = try values.decodeIfPresent(String.self, forKey: .url)
        owner = try values.decodeIfPresent(String.self, forKey: .owner)
        localUrl = try values.decodeIfPresent(String.self, forKey: .localUrl)
    }
    
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encodeIfPresent(name, forKey: .name)
        try values.encodeIfPresent(url, forKey: .url)
        try values.encodeIfPresent(owner, forKey: .owner)
        try values.encodeIfPresent(localUrl, forKey: .localUrl)
    }
}
