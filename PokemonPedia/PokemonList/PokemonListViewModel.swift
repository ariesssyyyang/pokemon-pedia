//
//  PokemonListViewModel.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import Foundation
import RxRelay
import RxSwift

final class PokemonListViewModel {

    enum FetchDataMode {
        case refresh, paging
    }

    struct State {
        let pokemons = BehaviorRelay<[PokemonInfo]>(value: [])
    }

    struct Event {
        let pokemonSaved = PublishRelay<String>()
    }

    // MARK: - Properties

    let state = State()
    let event = Event()

    private let repo: PokemonRepository
    private let bag = DisposeBag()

    // MARK: - Initializers

    init(repo: PokemonRepository = PokemonRepository()) {
        self.repo = repo

        bind()
    }

    // MARK: - Interfaces

    func fetchData(mode: FetchDataMode) {
        let pokemons = state.pokemons.value
        let offset: Int

        switch mode {
        case .paging:
            offset = pokemons.count
        case .refresh:
            offset = 0
        }

        repo.getPokemonList(offset: offset)
            .map { mode == .refresh ? $0 : (pokemons + $0) }
            .bind(to: state.pokemons)
            .disposed(by: bag)
    }

    private func bind() {
        event.pokemonSaved
            .withLatestFrom(state.pokemons) { savedName, all in
                guard let index = all.firstIndex(where: { $0.name == savedName }) else {
                    return all
                }

                // TODO: Save to local storage

                var pokemons = all
                pokemons[index].isSaved.toggle()
                return pokemons
            }
            .bind(to: state.pokemons)
            .disposed(by: bag)
    }
}
