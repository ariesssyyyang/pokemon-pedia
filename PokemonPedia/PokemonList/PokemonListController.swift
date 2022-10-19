//
//  PokemonListController.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import UIKit
import RxSwift

final class PokemonListController: UIViewController {

    private let viewModel = PokemonListViewModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        viewModel.fetchData(mode: .paging)
    }

    private func setupViews() {
        view.backgroundColor = .white

        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .orange

        refreshControl.rx.controlEvent(.valueChanged)
            .filter { refreshControl.isRefreshing }
            .subscribe(onNext: { [viewModel] _ in
                viewModel.fetchData(mode: .refresh)
            })
            .disposed(by: bag)

        viewModel.event.refreshed
            .observe(on: MainScheduler.instance)
            .filter { refreshControl.isRefreshing }
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .map { false }
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: bag)

        let tableView = UITableView()
        tableView.register(cellType: PokemonTableCell.self)
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl

        viewModel.state.pokemons
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { [viewModel] tableView, index, item in
                let cell = tableView.dequeueReusableCell(
                    for: IndexPath(row: index, section: 0),
                    cellType: PokemonTableCell.self
                )
                cell.configure(with: item)
                cell.saveButtonTapped.bind(to: viewModel.event.pokemonSaved).disposed(by: cell.bag)
                return cell
            }
            .disposed(by: bag)

        tableView.rx.willDisplayCell
            .filter { [viewModel] in viewModel.shouldLoadMore(at: $0.indexPath) }
            .subscribe(onNext: { [viewModel] _ in
                viewModel.fetchData(mode: .paging)
            })
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
