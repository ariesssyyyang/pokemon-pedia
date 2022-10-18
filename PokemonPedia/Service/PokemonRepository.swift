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
    private let localStore: PokemonDataStore

    init(
        remoteStore: PokemonDataStore = PokemonRemoteDataStore(),
        localStore: PokemonDataStore = PokemonLocalDataStore()
    ) {
        self.remoteStore = remoteStore
        self.localStore = localStore
    }

    func getPokemonList(offset: Int) -> Observable<[PokemonInfo]> {
        Observable<[PokemonInfo]>
            .zip(
                localStore.getPokemonList(offset: offset),
                remoteStore.getPokemonList(offset: offset)
            ) { local, remote in
                remote.map { remotePokemon in
                    var remotePokemon = remotePokemon
                    if local.contains(where: { $0.name == remotePokemon.name }) {
                        remotePokemon.isSaved = true
                    }
                    return remotePokemon
                }
            }
    }

    func savePokemon(_ pokemon: PokemonInfo) -> Result<PokemonInfo, Error> {
        localStore.savePokemon(pokemon)
    }

    func deletePokemon(_ pokemon: PokemonInfo) -> Result<PokemonInfo, Error> {
        localStore.deletePokemon(pokemon)
    }
}
