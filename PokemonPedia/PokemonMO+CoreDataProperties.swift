//
//  PokemonMO+CoreDataProperties.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/18.
//
//

import Foundation
import CoreData


extension PokemonMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonMO> {
        return NSFetchRequest<PokemonMO>(entityName: "PokemonMO")
    }

    @NSManaged public var name: String

}

extension PokemonMO : Identifiable {

}
