//
//  CrosswordWord.swift
//  Game2
//
//  Created by SDC-USER on 28/01/26.
//
import Foundation

enum WordDirection {
    case across
    case down
}

struct CrosswordWord {
    let answer: String
    let clue: String
    let startIndex: Int
    let direction: WordDirection
}

