//
//  APIError.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case statusCodeNotFound
    case decodeFailed(error: Error)
    case unexpected
}
