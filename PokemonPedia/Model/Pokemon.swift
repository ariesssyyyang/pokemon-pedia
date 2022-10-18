//
//  Pokemon.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import Foundation

struct PokemonInfo: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
    }

    let name: String
    var isSaved: Bool = false

    init(name: String, isSaved: Bool) {
        self.name = name
        self.isSaved = isSaved
    }
}

struct PokemonDetail: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id, name, height, weight, types, sprites
    }

    private enum SpriteKeys: String, CodingKey {
        case pictureURLString = "front_default"
    }

    struct PokemonType: Decodable {
        private enum CodingKeys: String, CodingKey {
            case name = "type"
            case order = "slot"
        }

        let order: Int
        let name: String
    }

    let id: Int
    let name: String
    let pictureURLString: String
    let height: Int
    let weight: Int
    let types: [PokemonType]

    var isSaved: Bool = false

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        height = try container.decode(Int.self, forKey: .height)
        weight = try container.decode(Int.self, forKey: .weight)
        types = try container.decode([PokemonType].self, forKey: .types)

        let sprites = try container.nestedContainer(keyedBy: SpriteKeys.self, forKey: .sprites)
        pictureURLString = try sprites.decode(String.self, forKey: .pictureURLString)
    }
}

struct PokemonListResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
        case value = "results"
    }

    let value: [PokemonInfo]
}
