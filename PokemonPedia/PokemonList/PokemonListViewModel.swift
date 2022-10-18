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

    func pokemon(at indexPath: IndexPath) -> PokemonInfo? {
        let pokemons = state.pokemons.value
        let index = indexPath.row
        guard pokemons.indices.contains(index) else { return nil }
        return pokemons[index]
    }

    private func bind() {
        // TODO: Refresh

        event.pokemonSaved
            .withLatestFrom(state.pokemons) { [repo] savedName, all in
                guard let index = all.firstIndex(where: { $0.name == savedName }) else {
                    return all
                }

                var pokemons = all
                let isSaved = pokemons[index].isSaved
                let notificationName: Notification.Name = isSaved ? .pokemonUnsaved : .pokemonSaved
                let result = isSaved
                    ? repo.deletePokemon(PokemonInfo(name: savedName, isSaved: true))
                    : repo.savePokemon(PokemonInfo(name: savedName, isSaved: false))

                switch result {
                case .success:
                    pokemons[index].isSaved.toggle()
                    NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["name": savedName])
                    return pokemons
                case .failure(let error):
                    assertionFailure("Failed to toggle save state. \nError: \(error)")
                    return all
                }
            }
            .bind(to: state.pokemons)
            .disposed(by: bag)

        Observable
            .merge(
                NotificationCenter.default.rx.notification(.pokemonSaved),
                NotificationCenter.default.rx.notification(.pokemonUnsaved)
            )
            .withLatestFrom(state.pokemons) { notification, all in
                guard
                    let name = notification.userInfo?["name"] as? String,
                    let index = all.firstIndex(where: { $0.name == name })
                else { return all }

                var pokemons = all
                pokemons[index].isSaved.toggle()
                return pokemons
            }
            .bind(to: state.pokemons)
            .disposed(by: bag)
    }
}
