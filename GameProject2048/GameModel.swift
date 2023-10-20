//
//  GameModel.swift
//  GameProject2048
//
//  Created by Milena Mirumyan on 25.09.23.
//

import Foundation

struct Position: Codable {
    let row: Int
    let col: Int
}

struct Blocks: Codable {
    var isMerged: Bool
    var number: Int
    var oldPosition: Position?
    var oldPositionMerged: Position?
}

final class GameModel {
    
    var matrix: [[Blocks]] = []
    var score: Int = 0 // the logic behind the score parameter is that when I merge two numbers my score is being incremented by the number I got, i.e. 4+4 = 8, my score will be incremented by 8 c
    var bestScore: Int  = 0
    var savedMatrix: [[Blocks]] = []
    var emptyCoordinates: [(Int, Int)] = [] // array for empty coordinates
    private var target: Int = 2
    private var matrixCopy: [[Blocks]] = []
    var retrievedMatrix: [[Blocks]] = []
    var maxTile: Int = 0

    init() {
        matrix = [
            [Blocks(isMerged: false, number: 0), Blocks(isMerged: false, number: 0), Blocks(isMerged: false, number: 0), Blocks(isMerged: false, number: 0)],
            [Blocks(isMerged: false, number: 0), Blocks(isMerged: false, number: 0), Blocks(isMerged: false, number: 0), Blocks(isMerged: false, number: 0)],
            [Blocks(isMerged: false, number: 0), Blocks(isMerged: false, number: 0), Blocks(isMerged: false, number: 0), Blocks(isMerged: false, number: 0)],
            [Blocks(isMerged: false, number: 0), Blocks(isMerged: false, number: 0), Blocks(isMerged: false, number: 0), Blocks(isMerged: false, number: 0)]
        ]
        matrixCopy = matrix
    }
    
    //MARK: - Addition Left
    func additionLeft() {
        createCopyMatrix()
        updateMerged()
        
        for row in 0...matrix.count - 1 {
            for col in 0...matrix.count - 1 {
                if matrix[row][col].number == 0 && col < matrix.count - 1 { //if my current element is 0, I have to switch it with my next element
                    matrix[row][col].number = matrix[row][col + 1].number
                    matrix[row][col].oldPosition = matrix[row][col + 1].oldPosition
                    matrix[row][col + 1].number = 0
                }
                if col > 0 && matrix[row][col - 1].number == matrix[row][col].number { //if my previous element and my current element are the same, I have to add them and put on my previous element's index
                    matrix[row][col - 1].number += matrix[row][col].number
                    matrix[row][col - 1].oldPositionMerged = matrix[row][col - 1].oldPosition
                    matrix[row][col - 1].oldPosition = matrix[row][col].oldPosition
                    matrix[row][col].number = 0
                    matrix[row][col - 1].isMerged = true
                    checkMaxTile(matrix[row][col - 1].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                    score += matrix[row][col - 1].number
                    if score >= bestScore {
                        bestScore = score
                    }
                }
                if col > 0 && matrix[row][col - 1].number == 0 { //if my previous element is 0, I am bringing my current element to my previous element's place
                    matrix[row][col - 1].number = matrix[row][col].number
                    matrix[row][col - 1].oldPosition = matrix[row][col].oldPosition
                    matrix[row][col].number = 0
                    if col - 1 > 0 && matrix[row][col - 2].number == matrix[row][col - 1].number && !matrix[row][col - 2].isMerged && !matrix[row][col - 1].isMerged {
                        matrix[row][col - 2].number += matrix[row][col - 1].number
                        matrix[row][col - 2].oldPositionMerged = matrix[row][col - 2].oldPosition
                        matrix[row][col - 2].oldPosition = matrix[row][col - 1].oldPosition
                        checkMaxTile(matrix[row][col - 2].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                        matrix[row][col - 1].number = 0
                        score += matrix[row][col - 2].number
                        if score >= bestScore {
                            bestScore = score
                        }
                    }
                    if col - 1 > 0 && matrix[row][col - 2].number == 0 {
                        matrix[row][col - 2].number = matrix[row][col - 1].number
                        matrix[row][col - 2].oldPosition = matrix[row][col - 1].oldPosition
                        matrix[row][col - 1].number = 0
                    }
                }
            }
        }
    }
    
    //MARK: - Addition Right
    func additionRight() {
        createCopyMatrix()
        updateMerged()
        
        for row in 0...matrix.count - 1 {
            for col in stride(from: matrix.count - 1, to: -1, by: -1) { //if my current element is 0, I have to switch it with my previous element
                if col > 0 && matrix[row][col].number == 0 {
                    matrix[row][col].number = matrix[row][col - 1].number
                    matrix[row][col].oldPosition = matrix[row][col - 1].oldPosition
                    matrix[row][col - 1].number = 0
                }
                if col < matrix.count - 1 && matrix[row][col].number == matrix[row][col + 1].number { //if my next element and my current element are the same, I have to add them and put on my next element's index
                    matrix[row][col + 1].number += matrix[row][col].number
                    matrix[row][col + 1].oldPositionMerged = matrix[row][col + 1].oldPosition
                    matrix[row][col + 1].oldPosition = matrix[row][col].oldPosition
                    matrix[row][col].number = 0
                    matrix[row][col + 1].isMerged = true
                    checkMaxTile(matrix[row][col + 1].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                    score += matrix[row][col + 1].number
                    updateBestScore()
                }
                if col < matrix.count - 1 && matrix[row][col + 1].number == 0 { //if my previous element is 0, I am bringing my current element under my next element's index
                    matrix[row][col + 1].number = matrix[row][col].number
                    matrix[row][col + 1].oldPosition = matrix[row][col].oldPosition
                    matrix[row][col].number = 0
                    if col + 1 < matrix.count - 1 && matrix[row][col + 2].number == matrix[row][col + 1].number && !matrix[row][col + 2].isMerged && !matrix[row][col + 1].isMerged {
                        matrix[row][col + 2].number += matrix[row][col + 1].number
                        matrix[row][col + 2].oldPositionMerged = matrix[row][col + 2].oldPosition
                        matrix[row][col + 2].oldPosition = matrix[row][col + 1].oldPosition
                        checkMaxTile(matrix[row][col + 2].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                        matrix[row][col + 1].number = 0
                        score += matrix[row][col + 2].number
                        updateBestScore()
                    }
                    if col + 2 < matrix.count && matrix[row][col + 2].number == 0 {
                        matrix[row][col + 2].number = matrix[row][col + 1].number
                        matrix[row][col + 2].oldPosition = matrix[row][col + 1].oldPosition
                        matrix[row][col + 1].number = 0
                    }
                }
            }
        }
    }
    
    //MARK: - Addition Top
    func additionTop() {
        createCopyMatrix()
        updateMerged()
        
        for col in 0...matrix.count - 1 { // going over the columns
            for row in 0...matrix.count - 1 {   //going over the rows
                if matrix[row][col].number == 0 && row < matrix.count - 1 { //checking if my current element is 0 and if it is, I have to change my next row number to my current one
                    matrix[row][col].number = matrix[row + 1][col].number
                    matrix[row][col].oldPosition = matrix[row + 1][col].oldPosition
                    matrix[row + 1][col].number = 0
                }
                if row > 0 && matrix[row - 1][col].number == matrix[row][col].number { //checking if my previous element is equal to my current element, adding them and setting to previous element's place
                    matrix[row - 1][col].number += matrix[row][col].number
                    matrix[row - 1][col].oldPositionMerged = matrix[row - 1][col].oldPosition
                    matrix[row - 1][col].oldPosition = matrix[row][col].oldPosition
                    matrix[row][col].number = 0
                    matrix[row - 1][col].isMerged = true
                    checkMaxTile(matrix[row - 1][col].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                    score += matrix[row - 1][col].number
                    updateBestScore()
                }
                if row > 0 && matrix[row - 1][col].number == 0 { //checking if my previous element is 0, and switching their places
                    matrix[row - 1][col].number = matrix[row][col].number
                    matrix[row - 1][col].oldPosition = matrix[row][col].oldPosition
                    matrix[row][col].number = 0
                    if row - 1 > 0 && matrix[row-2][col].number == matrix[row - 1][col].number && !matrix[row-2][col].isMerged && !matrix[row - 1][col].isMerged {
                        matrix[row - 2][col].number += matrix[row - 1][col].number
                        matrix[row - 2][col].oldPositionMerged = matrix[row - 2][col].oldPosition
                        matrix[row - 2][col].oldPosition = matrix[row - 1][col].oldPosition
                        checkMaxTile(matrix[row - 2][col].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                        matrix[row - 1][col].number = 0
                        score += matrix[row - 2][col].number
                        updateBestScore()
                    }
                    if row - 1 > 0 && matrix[row - 2][col].number == 0 {
                        matrix[row - 2][col].number = matrix[row - 1][col].number
                        matrix[row - 2][col].oldPosition = matrix[row - 1][col].oldPosition
                        matrix[row - 1][col].number = 0
                        
                    }
                } //thus, I covered all the possible cases
            }
        }
    }
    
    //MARK: - Addition Bottom
    func additionBottom() {
        createCopyMatrix()
        updateMerged()
        
        for col in 0...matrix.count - 1 {  //going over the columns
            for row in stride(from: matrix.count - 1, to: -1, by: -1) { //going over the rows
                if matrix[row][col].number == 0 && row > 0 { // checking if my current element is 0, and switching it with the previous one
                    matrix[row][col].number = matrix[row - 1][col].number
                    matrix[row][col].oldPosition = matrix[row - 1][col].oldPosition
                    matrix[row - 1][col].number = 0
                }
                if row < matrix.count - 1 && matrix[row + 1][col].number == matrix[row][col].number { // checking if my current element is equal to my next one, I am adding those numbers and put them into my element
                    matrix[row + 1][col].number += matrix[row][col].number
                    matrix[row + 1][col].oldPosition = matrix[row + 1][col].oldPosition
                    matrix[row + 1][col].oldPositionMerged = matrix[row + 1][col].oldPosition
                    matrix[row][col].number = 0
                    matrix[row + 1][col].isMerged = true
                    checkMaxTile(matrix[row + 1][col].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                    score += matrix[row + 1][col].number
                    updateBestScore()
                }
                if row < matrix.count - 1 && matrix[row + 1][col].number == 0 { // checking if my next element is 0, I switch my current element with the next one
                    matrix[row + 1][col].number = matrix[row][col].number
                    matrix[row + 1][col].oldPosition = matrix[row][col].oldPosition
                    matrix[row][col].number = 0
                    if row + 1 < matrix.count - 1 && matrix[row + 2][col].number == matrix[row + 1][col].number && !matrix[row + 2][col].isMerged && !matrix[row + 1][col].isMerged {
                        matrix[row + 2][col].number += matrix[row + 1][col].number
                        matrix[row + 2][col].oldPositionMerged = matrix[row + 2][col].oldPosition
                        matrix[row + 2][col].oldPosition = matrix[row + 1][col].oldPosition
                        matrix[row + 1][col].number = 0
                        checkMaxTile(matrix[row + 2][col].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                        score += matrix[row + 2][col].number
                        updateBestScore()
                    }
                    if row + 2 < matrix.count && matrix[row + 2][col].number == 0 {
                        matrix[row + 2][col].number = matrix[row + 1][col].number
                        matrix[row + 2][col].oldPosition = matrix[row + 1][col].oldPosition
                        matrix[row + 1][col].number = 0
                        
                    }
                }
            }
        }
//        updateMerged()
//        checkAndGenerate()
    }
        
    //MARK: - Saving Algorithm
    func save() {  //keeping our matrix and best score in UserDefaults, so that when I kill my app and go back to it, I can have access on the matrix and best score
        savedMatrix = matrix
        //saving the matrix
        let encoderForMatrix = JSONEncoder()
        if let data = try? encoderForMatrix.encode(savedMatrix) {
            UserDefaults.standard.set(data, forKey: "savedMatrix")
        }
        //saving the best score
        let encoderForBestScore = JSONEncoder()
        if let data = try? encoderForBestScore.encode(bestScore) {
            UserDefaults.standard.set(data, forKey: "savedBestScore")
        }
        //saving the current score
        let encoderForCurrentScore = JSONEncoder()
        if let data = try? encoderForCurrentScore.encode(score) {
            UserDefaults.standard.set(data, forKey: "CurrentScore")
        }
        //saving the max tile
        let encoderForMaxTile = JSONEncoder()
        if let data = try? encoderForMaxTile.encode(maxTile) {
            UserDefaults.standard.set(data, forKey: "MaxTile")
        }
    }
    
    func retrieveSaved() {    //this is the backwards process, I retrieve my saved matrix and best score
        //for matrix
        if let data = UserDefaults.standard.data(forKey: "savedMatrix"),
           let decodedArray = try? JSONDecoder().decode([[Blocks]].self, from: data) {
            retrievedMatrix = decodedArray
            matrix = retrievedMatrix
        }
        // for the best score
        if let highestScore = UserDefaults.standard.data(forKey: "savedBestScore"),
           let decodedScore = try? JSONDecoder().decode(Int.self, from: highestScore) {
            bestScore = decodedScore
        }
        //for the current score
        if let currentScore = UserDefaults.standard.data(forKey: "CurrentScore"),
           let decodedCScore = try? JSONDecoder().decode(Int.self, from: currentScore) {
            score = decodedCScore
        }
        
        //for the max tile
        if let max = UserDefaults.standard.data(forKey: "MaxTile"),
           let decodedMaxTile = try? JSONDecoder().decode(Int.self, from: max) {
            maxTile = decodedMaxTile
        }
    }
    
    //MARK: - Generating random number at random empty coordinate
    func generateRandomCoordinates() {
        emptyCoordinates = [] //removing its coordinates since it is not empty
        for rowIndex in 0..<matrix.count {
            for columnIndex in 0..<matrix[rowIndex].count {
                if matrix[rowIndex][columnIndex].number == 0 {
                    emptyCoordinates.append((rowIndex, columnIndex))
                }
            }
        }
        guard !emptyCoordinates.isEmpty else {
            print("emptyCoordinates array is empty")
            return
        }
    }
    
    func generateNewNumberForMatrix() -> Position {
        let number = 2 * Int.random(in: 1...2)
        generateRandomCoordinates() //emptyCoordinates
        //generate random index within empty coordinates in matrix
        let randomIndex = Int.random(in: 0..<emptyCoordinates.count)
        let (row, column) = emptyCoordinates[randomIndex] //picking the coordinates
        //adding the number into matrix
        matrix[row][column].number = number
        return Position(row: row, col: column)
    }
    
    //MARK: Helper Methods
    func checkMaxTile(_ number: Int) {
        if maxTile < number {
            maxTile = number
        }
    }
    
    //helper function to update my isMerged property after doing the addition
    func updateMerged() {
        for row in 0...matrix.count - 1 {
            for col in 0...matrix.count - 1 {
                matrix[row][col].isMerged = false
                matrix[row][col].oldPosition = Position(row: row, col: col)
                matrix[row][col].oldPositionMerged = nil
            }
        }
    }
    
    //helper function to understand has my matrix changed or no
    func hasChanged(matrix: [[Blocks]]) -> Bool {
        var answer = false
        for row in 0...matrix.count - 1 {
            for col in 0...matrix.count - 1 {
                if matrix[row][col].number != matrixCopy[row][col].number {
                    answer = true
                }
            }
        }
        return answer
    }
    
    //helper method to update the best score if needed
    func updateBestScore() {
        if score >= bestScore {
            bestScore = score
        }
    }
    
    //helper method to create copy of my matrix at exact moment
    func createCopyMatrix() {
        for row in 0...matrix.count - 1 {
            for col in 0...matrix.count - 1 {
                matrixCopy[row][col] = matrix[row][col]
            }
        }
    }
    
    func checkAndGenerate() -> Position? {
        if hasChanged(matrix: matrix) {  //if adding to the bottom my matrix doesn't change I should not generate new random number
            return generateNewNumberForMatrix()
        } else {
            generateRandomCoordinates() // generating random coordinates for updating
            return nil
        }
    }
    
    //checks if the user lost the game or not(the matrix is full...)
    func needToTerminate() -> Bool {
        // Check for horizontal (right) neighbors
        for row in 0..<matrix.count {
            for col in 0..<matrix.count - 1 {
                if matrix[row][col].number == matrix[row][col + 1].number {
                    return false
                }
            }
        }
        
        // Check for vertical (below) neighbors
        for col in 0..<matrix.count {
            for row in 0..<matrix.count - 1 {
                if matrix[row][col].number == matrix[row + 1][col].number {
                    return false
                }
            }
        }
        return true
    }
}


