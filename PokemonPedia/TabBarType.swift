//
//  TabBarType.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import UIKit

enum TabBarType {
    case list, saved

    var title: String? {
        switch self {
        case .saved:
            return "Saved"
        case .list:
            return "Pokémon"
        }
    }

    var image: UIImage? {
        switch self {
        case .saved:
            return UIImage(systemName: "bookmark")
        case .list:
            return UIImage(systemName: "books.vertical")
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .saved:
            return UIImage(systemName: "bookmark.fill")
        case .list:
            return UIImage(systemName: "books.vertical.fill")
        }
    }
}
