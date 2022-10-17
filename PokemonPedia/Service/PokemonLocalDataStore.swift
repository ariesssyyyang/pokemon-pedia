//
//  PokemonLocalDataStore.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import Foundation
import RxSwift

final class PokemonLocalDataStore: PokemonDataStore {
    func getPokemonList(offset: Int) -> Observable<[PokemonInfo]> {
        .empty()
    }
}
