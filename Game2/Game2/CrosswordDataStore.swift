//
//  CrosswordDataStore.swift
//  Game2
//
//  Created by SDC-USER on 28/01/26.
//

import Foundation

struct CrosswordEntry {
    let word: String
    let clue: String
}

struct CrosswordDataStore {

    static let fruits: [CrosswordEntry] = [
        CrosswordEntry(
            word: "APPLE",
            clue: "A fruit that keeps the doctor away"
        ),
        CrosswordEntry(
            word: "BANANA",
            clue: "A long yellow fruit rich in potassium"
        ),
        CrosswordEntry(
            word: "ORANGE",
            clue: "A citrus fruit and a color"
        ),
        CrosswordEntry(
            word: "GRAPE",
            clue: "Small fruit often used to make wine"
        )
    ]

    static let finance: [CrosswordEntry] = [
        CrosswordEntry(
            word: "ASSET",
            clue: "Something valuable owned by a person or company"
        ),
        CrosswordEntry(
            word: "STOCK",
            clue: "A share representing ownership in a company"
        )
    ]
}

