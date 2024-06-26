//
//  TextModel.swift
//  FullstackApp
//
//  Created by Maxwell Wayne on 4/10/24.
//

import Foundation

struct TextModel: Codable {
    let _id: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case _id = "_id"
        case text = "text"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(String.self, forKey: ._id)
        self.text = try container.decode(String.self, forKey: .text)
    }
    
    init(id: String, text: String) {
        self._id = id
        self.text = text
    }
}
