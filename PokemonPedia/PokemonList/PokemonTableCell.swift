//
//  PokemonTableCell.swift
//  PokemonPedia
//
//  Created by Aries Yang on 2022/10/17.
//

import UIKit
import Reusable
import RxCocoa
import RxSwift

final class PokemonTableCell: UITableViewCell, Reusable {

    var saveButtonTapped: Observable<String> {
        saveButtonTappedRelay.asObservable()
    }

    private let saveButtonTappedRelay = PublishRelay<String>()
    private(set) var bag = DisposeBag()

    private let nameLabel = UILabel()
    private let saveButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    // MARK: - Setup

    private func setupViews() {
        selectionStyle = .none

        nameLabel.font = .boldSystemFont(ofSize: 20.0)

        saveButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        saveButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        saveButton.setContentHuggingPriority(.required, for: .horizontal)

        saveButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
        }

        let stackView = UIStackView(arrangedSubviews: [nameLabel, saveButton])
        stackView.spacing = 8.0
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 1.0
        stackView.layer.cornerRadius = 8.0
        stackView.clipsToBounds = true

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
            )
        }
    }

    // MARK: - Interfaces

    func configure(with item: PokemonInfo) {
        nameLabel.text = item.name
        saveButton.isSelected = item.isSaved

        saveButton.rx.tap.map { item.name }.bind(to: saveButtonTappedRelay).disposed(by: bag)
    }
}
