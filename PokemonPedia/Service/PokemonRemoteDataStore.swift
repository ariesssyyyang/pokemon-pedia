//
//  PokemonRemoteDataStore.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import Foundation
import RxSwift

final class PokemonRemoteDataStore: PokemonDataStore {
    func getPokemonList(offset: Int) -> Observable<[PokemonInfo]> {
        APIManager.shared
            .request(service: PokemonService.list(offset: offset))
            .asObservable()
            .map { (response: PokemonListResponse) in response.value }
    }

    func savePokemon(_ pokemon: PokemonInfo) -> Result<PokemonInfo, Error> {
        .success(pokemon)
    }

    func deletePokemon(_ pokemon: PokemonInfo) -> Result<PokemonInfo, Error> {
        .success(pokemon)
    }

    func getPokemonDetail(name: String) -> Observable<PokemonDetail> {
        APIManager.shared
            .request(service: PokemonService.detail(name: name))
            .asObservable()
    }
}
