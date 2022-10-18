//
//  PokemonDetailController.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/18.
//

import UIKit
import RxSwift

final class PokemonDetailController: UIViewController {

    private let viewModel: PokemonDetailViewModel
    private let bag = DisposeBag()

    init(info: PokemonInfo) {
        self.viewModel = PokemonDetailViewModel(info: info)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        viewModel.fetchData()
    }

    private func setupViews() {
        let dismissButton = UIButton()
        dismissButton.tintColor = .black
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20.0, height: 20.0))
        }
        dismissButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { `self`, _ in
                self.dismiss(animated: true)
            })
            .disposed(by: bag)

        let nameLabel = UILabel()
        nameLabel.text = viewModel.info.name
        nameLabel.font = .boldSystemFont(ofSize: 24.0)
        nameLabel.textAlignment = .center

        let saveButton = UIButton()
        saveButton.tintColor = .black
        saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        saveButton.rx.tap.bind(to: viewModel.event.buttonTapped).disposed(by: bag)
        saveButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20.0, height: 20.0))
        }

        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let headerStackView = UIStackView(arrangedSubviews: [dismissButton, nameLabel, saveButton])
        headerStackView.spacing = 8.0
        headerStackView.alignment = .center

        let idTitleLabel = makeLabel(text: "ID: ")
        let heightTitleLabel = makeLabel(text: "Height: ")
        let weightTitleLabel = makeLabel(text: "Weight: ")
        let typesTitleLabel = makeLabel(text: "Types: ")

        let titleStackView = UIStackView(
            arrangedSubviews: [idTitleLabel, heightTitleLabel, weightTitleLabel, typesTitleLabel]
        )
        titleStackView.axis = .vertical
        titleStackView.spacing = 8.0

        let idLabel = makeLabel()
        let heightLabel = makeLabel()
        let weightLabel = makeLabel()
        let typesLabel = makeLabel()

        let pokemonDetail = viewModel.state.pokemon.compactMap { $0 }.share()

        pokemonDetail
            .map { "\($0.id)" }
            .bind(to: idLabel.rx.text)
            .disposed(by: bag)

        pokemonDetail
            .map { "\($0.height)" }
            .bind(to: heightLabel.rx.text)
            .disposed(by: bag)

        pokemonDetail
            .map { "\($0.weight)" }
            .bind(to: weightLabel.rx.text)
            .disposed(by: bag)

        pokemonDetail
            .map { detail in
                detail.types.map { $0.name }.joined(separator: ", ")
            }
            .bind(to: typesLabel.rx.text)
            .disposed(by: bag)

        pokemonDetail
            .map { $0.isSaved }
            .bind(to: saveButton.rx.isSelected)
            .disposed(by: bag)

        pokemonDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { detail in
                imageView.kf.setImage(with: URL(string: detail.pictureURLString))
            })
            .disposed(by: bag)

        let valueStackView = UIStackView(
            arrangedSubviews: [idLabel, heightLabel, weightLabel, typesLabel]
        )
        valueStackView.axis = .vertical
        valueStackView.spacing = 8.0

        let infoStackView = UIStackView(arrangedSubviews: [titleStackView, valueStackView])
        infoStackView.distribution = .fillEqually

        let stackView = UIStackView(arrangedSubviews: [
            headerStackView,
            imageView,
            infoStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 8.0
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)

        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32.0)
            $0.centerY.equalToSuperview()
        }
    }

    private func makeLabel(text: String? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .monospacedSystemFont(ofSize: 14.0, weight: .regular)
        return label
    }
}
