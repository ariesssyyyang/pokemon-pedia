//
//  TabBarItem.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import UIKit

final class TabBarItem: UITabBarItem {

    // MARK: - Initializers

    init(type: TabBarType) {
        super.init()
        self.title = type.title
        self.image = type.image
        self.selectedImage = type.selectedImage        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
