//
//  ViewController.swift
//  Game2
//
//  Created by SDC-USER on 28/01/26.
//

import UIKit

class ViewController: UIViewController,
                      UICollectionViewDataSource,
                      UICollectionViewDelegate,
                      UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var clueLabel: UILabel!

    private let gridSize = 9
    private var cells: [CrosswordCell] = []
    private var words: [CrosswordWord] = []
    private var crosswordWords: [CrosswordEntry] = []

    private var selectedWord: CrosswordWord?
    private var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        crosswordWords = CrosswordDataStore.fruits
        setupCollectionView()
        buildPuzzle()
        
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2

        collectionView.collectionViewLayout = layout
    }
    
    private func buildPuzzle() {

        cells = (0..<81).map { index in
            CrosswordCell(
                index: index,
                row: index / 9,
                col: index % 9,
                letter: nil,
                correctLetter: nil,
                isBlocked: true
            )
        }

        // Define words manually
        let apple = CrosswordWord(
            answer: "APPLE",
            clue: "A fruit that keeps the doctor away",
            startIndex: 10,
            direction: .across
        )

        let pen = CrosswordWord(
            answer: "PEN",
            clue: "Used to write",
            startIndex: 12,
            direction: .down
        )

        words = [apple, pen]

        placeWord(apple)
        placeWord(pen)

        selectedWord = apple
        selectedIndex = apple.startIndex
        highlightWord(apple)
        clueLabel.text = apple.clue

        collectionView.reloadData()
    }
    
    private func placeWord(_ word: CrosswordWord) {
        var row = cells[word.startIndex].row
        var col = cells[word.startIndex].col

        for char in word.answer {
            let idx = row * gridSize + col
            cells[idx].isBlocked = false
            cells[idx].correctLetter = char

            if word.direction == .across {
                col += 1
            } else {
                row += 1
            }
        }
    }
    private func highlightWord(_ word: CrosswordWord) {
        for i in cells.indices {
            cells[i].isHighlighted = false
            cells[i].isSelected = false
        }

        var row = cells[word.startIndex].row
        var col = cells[word.startIndex].col

        for _ in word.answer {
            let idx = row * gridSize + col
            cells[idx].isHighlighted = true

            if word.direction == .across {
                col += 1
            } else {
                row += 1
            }
        }

        cells[word.startIndex].isSelected = true
    }
    func insertLetter(_ char: Character) {
        var cell = cells[selectedIndex]
        guard !cell.isBlocked else { return }

        cell.letter = char
        if let correct = cell.correctLetter {
            cell.isCorrect = char.lowercased() == correct.lowercased()
        }

        cells[selectedIndex] = cell

        moveForward()
        collectionView.reloadData()
    }
    private func moveForward() {
        guard let word = selectedWord else { return }

        var row = cells[selectedIndex].row
        var col = cells[selectedIndex].col

        if word.direction == .across {
            col += 1
        } else {
            row += 1
        }

        let nextIndex = row * gridSize + col
        if nextIndex < cells.count && !cells[nextIndex].isBlocked {
            selectedIndex = nextIndex
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cells.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "GridCell",
            for: indexPath
        ) as! GridCell

        cell.configure(with: cells[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let side = collectionView.bounds.width / 9 - 2
        return CGSize(width: side, height: side)
    }
}

