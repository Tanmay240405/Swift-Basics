//
//  CrosswordCellModel.swift
//  Game2
//
//  Created by SDC-USER on 28/01/26.
//
import Foundation

struct CrosswordCell {
    let index: Int
    let row: Int
    let col: Int

    var letter: Character?
    var correctLetter: Character?

    var isBlocked: Bool
    var isSelected: Bool = false
    var isHighlighted: Bool = false
    var isCorrect: Bool = false
}

