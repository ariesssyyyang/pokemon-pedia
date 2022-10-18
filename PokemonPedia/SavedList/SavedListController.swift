//
//  SavedListController.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import UIKit
import RxSwift

final class SavedListController: UIViewController {

    private let viewModel = SavedListViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        viewModel.fetchData()
    }

    private func setupViews() {
        view.backgroundColor = .white

        let tableView = UITableView()
        tableView.register(cellType: PokemonTableCell.self)
        tableView.separatorStyle = .none

        viewModel.state.pokemons
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { [viewModel] tableView, index, item in
                let cell = tableView.dequeueReusableCell(
                    for: IndexPath(row: index, section: 0),
                    cellType: PokemonTableCell.self
                )
                cell.configure(with: item)
                cell.saveButtonTapped.bind(to: viewModel.event.pokemonUnsaved).disposed(by: cell.bag)
                return cell
            }
            .disposed(by: bag)

        tableView.rx.itemSelected
            .compactMap { [viewModel] in viewModel.pokemon(at: $0) }
            .subscribe(with: self, onNext: { `self`, pokemon in
                let controller = PokemonDetailController(info: pokemon)
                self.present(controller, animated: true)
            })
            .disposed(by: bag)

        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
