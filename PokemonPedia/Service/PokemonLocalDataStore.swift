//
//  PokemonLocalDataStore.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import Foundation
import RxSwift
import CoreData

final class PokemonLocalDataStore: PokemonDataStore {

    private let managedContext: NSManagedObjectContext

    init() {
        self.managedContext = AppDelegate.shared.persistentContainer.viewContext
    }

    func getPokemonList(offset: Int) -> Observable<[PokemonInfo]> {
        return Observable<[PokemonInfo]>.create { [managedContext] observer in
            let fetchRequest = NSFetchRequest<PokemonMO>(entityName: "PokemonMO")

            do {
                let pokemons = try managedContext.fetch(fetchRequest).map {
                    PokemonInfo(name: $0.name, isSaved: true)
                }
                observer.onNext(pokemons)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
    }

    func savePokemon(_ pokemon: PokemonInfo) -> Result<PokemonInfo, Error> {
        let pokemonMO = PokemonMO(context: managedContext)
        pokemonMO.setValue(pokemon.name, forKey: "name")

        do {
            try managedContext.save()
            return .success(pokemon)
        } catch {
            return .failure(error)
        }
    }

    func deletePokemon(_ pokemon: PokemonInfo) -> Result<PokemonInfo, Error> {
        let fetchRequest = PokemonMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", pokemon.name)

        do {
            let pokemonMOs = try managedContext.fetch(fetchRequest)
            guard let deleted = pokemonMOs.first else {
                return .failure(LocalStoreError.deleteFailed)
            }
            managedContext.delete(deleted)

            try managedContext.save()
            return .success(pokemon)
        } catch {
            return .failure(error)
        }
    }

    func getPokemonDetail(name: String) -> Observable<PokemonDetail> {
        .empty()
    }
}
