//
//  WebService.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import Foundation

protocol WebService {
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: String]? { get }
}

extension WebService {
    var baseURL: String { "https://pokeapi.co" }
    var parameters: [String: String]? { nil }
}

extension WebService {
    var version: String { "/api/v2" }
}
