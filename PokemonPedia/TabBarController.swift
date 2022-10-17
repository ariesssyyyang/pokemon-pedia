//
//  TabBarController.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import UIKit

final class TabBarController: UITabBarController {

    // MARK: - Initializers

    init(types: [TabBarType]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = types.map(makeViewController(type:))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Factory

    private func makeViewController(type: TabBarType) -> UIViewController {
        let viewController: UIViewController
        switch type {
        case .list:
            viewController = PokemonListController()
        case .saved:
            viewController = SavedListController()
        }
        viewController.tabBarItem = TabBarItem(type: type)

        return viewController
    }
}
