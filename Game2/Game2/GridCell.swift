//
//  GridCell.swift
//  Game2
//
//  Created by SDC-USER on 28/01/26.
//

import UIKit

final class GridCell: UICollectionViewCell {

    @IBOutlet weak var letterLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        letterLabel.text = ""
        contentView.backgroundColor = .systemGray5
        layer.borderWidth = 0
    }

    func configure(with model: CrosswordCell) {
        if model.isBlocked {
            contentView.backgroundColor = .systemGray2
            letterLabel.text = ""
            return
        }

        letterLabel.text = model.letter?.uppercased()

        if model.isSelected {
            contentView.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        } else if model.isHighlighted {
            contentView.backgroundColor = .systemYellow.withAlphaComponent(0.3)
        } else {
            contentView.backgroundColor = .systemGray5
        }

        if model.isCorrect {
            contentView.backgroundColor = .systemGreen.withAlphaComponent(0.4)
        }

        layer.cornerRadius = 6
    }
}

