//
//  PokemonDetailViewModel.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/18.
//

import Foundation
import RxRelay
import RxSwift

final class PokemonDetailViewModel {

    struct State {
        let pokemon = BehaviorRelay<PokemonDetail?>(value: nil)
    }

    struct Event {
        let buttonTapped = PublishRelay<Void>()
    }

    let info: PokemonInfo
    let state = State()
    let event = Event()

    private let repo: PokemonRepository
    private let bag = DisposeBag()

    init(repo: PokemonRepository = PokemonRepository(), info: PokemonInfo) {
        self.repo = repo
        self.info = info

        bind()
    }

    func fetchData() {
        repo.getPokemonDetail(name: info.name)
            .map { [info] in
                var pokemon = $0
                pokemon.isSaved = info.isSaved
                return pokemon
            }
            .bind(to: state.pokemon)
            .disposed(by: bag)
    }

    private func bind() {
        event.buttonTapped
            .withLatestFrom(state.pokemon)
            .compactMap { [repo, info] pokemon -> PokemonDetail? in
                guard var pokemon = pokemon else { return nil }
                let isSaved = info.isSaved
                let pokemonInfo = PokemonInfo(name: pokemon.name, isSaved: isSaved)
                let notificationName: Notification.Name = isSaved ? .pokemonUnsaved : .pokemonSaved
                let result = isSaved ? repo.deletePokemon(pokemonInfo) : repo.savePokemon(pokemonInfo)

                switch result {
                case .success:
                    pokemon.isSaved = !isSaved
                    NotificationCenter.default.post(
                        name: notificationName,
                        object: nil,
                        userInfo: ["name": pokemon.name]
                    )
                case .failure(let error):
                    print("😡 Failed to toggle save button.\nError: \(error)")
                }

                return pokemon
            }
            .bind(to: state.pokemon)
            .disposed(by: bag)
    }
}
