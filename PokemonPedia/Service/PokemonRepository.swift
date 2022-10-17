//
//  PokemonRepository.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import Foundation
import RxSwift

final class PokemonRepository {

    private let remoteStore: PokemonDataStore

    init(remoteStore: PokemonDataStore = PokemonRemoteDataStore()) {
        self.remoteStore = remoteStore
    }

    func getPokemonList(offset: Int) -> Observable<[PokemonInfo]> {
        remoteStore.getPokemonList(offset: offset)
    }
}
