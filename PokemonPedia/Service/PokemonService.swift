//
//  PokemonService.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import Foundation

enum PokemonService: WebService {
    case list(offset: Int)
    case detail(name: String)

    var path: String {
        switch self {
        case .list:
            return "/pokemon"
        case .detail(let name):
            return "/pokemon/\(name)"
        }
    }

    var parameters: [String : String]? {
        switch self {
        case .list(let offset):
            return ["offset": "\(offset)"]
        case .detail:
            return nil
        }
    }
}
