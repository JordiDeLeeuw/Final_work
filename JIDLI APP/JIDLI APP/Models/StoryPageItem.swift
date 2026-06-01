//
//  StoryPageItem.swift
//  JIDLI APP
//
//  Created by Jordi De Leeuw on 31/05/2026.
//
//  datamodel voor 1 specifieke pagina in het verhaal
//

import Foundation

struct StoryPage: Codable, Identifiable, Equatable {
    let pageNumber: Int
    let text: String
    let imageName: String
    var id: Int { pageNumber }

    // zorgt dat de swift data exact matcht met je story_data.json
    enum CodingKeys: String, CodingKey {
        case pageNumber
        case text
        case imageName
    }
}
