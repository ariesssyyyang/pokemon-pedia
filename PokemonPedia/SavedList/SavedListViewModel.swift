//
//  SavedListViewModel.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/18.
//

import Foundation
import RxRelay
import RxSwift

final class SavedListViewModel {

    struct State {
        let pokemons = BehaviorRelay<[PokemonInfo]>(value: [])
    }

    struct Event {
        let pokemonUnsaved = PublishRelay<String>()
    }

    // MARK: - Properties

    let state = State()
    let event = Event()

    private let store: PokemonDataStore
    private let bag = DisposeBag()

    // MARK: - Initializers

    init(store: PokemonDataStore = PokemonLocalDataStore()) {
        self.store = store

        bind()
    }

    // MARK: - Interfaces

    func fetchData() {
        store.getPokemonList(offset: 0)
            .bind(to: state.pokemons)
            .disposed(by: bag)
    }

    private func bind() {
        // TODO: Refresh

        event.pokemonUnsaved
            .withLatestFrom(state.pokemons) { [store] unsavedName, all in
                guard let index = all.firstIndex(where: { $0.name == unsavedName }) else {
                    return all
                }

                var pokemons = all
                let result = store.deletePokemon(PokemonInfo(name: unsavedName, isSaved: true))

                switch result {
                case .success:
                    pokemons.remove(at: index)
                    NotificationCenter.default.post(name: .pokemonUnsaved, object: nil, userInfo: ["name": unsavedName])
                    return pokemons
                case .failure(let error):
                    assertionFailure("Failed to toggle save state. \nError: \(error)")
                    return all
                }
            }
            .bind(to: state.pokemons)
            .disposed(by: bag)

        NotificationCenter.default.rx.notification(.pokemonSaved)
            .withLatestFrom(state.pokemons) { notification, all in
                guard let savedName = notification.userInfo?["name"] as? String else { return all }
                return all + [PokemonInfo(name: savedName, isSaved: true)]
            }
            .bind(to: state.pokemons)
            .disposed(by: bag)
    }
}
