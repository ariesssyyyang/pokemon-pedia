//
//  PokemonDataStore.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import Foundation
import RxSwift

protocol PokemonDataStore {
    func getPokemonList(offset: Int) -> Observable<[PokemonInfo]>
}
