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
                    updateOldPosition(&matrix[row][col], matrix[row][col + 1])
                    matrix[row][col + 1].number = 0
                }
                if col > 0 && matrix[row][col - 1].number == matrix[row][col].number { //if my previous element and my current element are the same, I have to add them and put on my previous element's index
                    matrix[row][col - 1].number += matrix[row][col].number
                    matrix[row][col - 1].oldPositionMerged = matrix[row][col - 1].oldPosition
                    updateOldPosition(&matrix[row][col - 1], matrix[row][col])
                    matrix[row][col].number = 0
                    matrix[row][col - 1].isMerged = true
                    checkMaxTile(matrix[row][col - 1].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                    score += matrix[row][col - 1].number
                    updateBestScore()
                }
                if col > 0 && matrix[row][col - 1].number == 0 { //if my previous element is 0, I am bringing my current element to my previous element's place
                    matrix[row][col - 1].number = matrix[row][col].number
                    updateOldPosition(&matrix[row][col - 1], matrix[row][col])
                    matrix[row][col].number = 0
                    if col - 1 > 0 && matrix[row][col - 2].number == matrix[row][col - 1].number && !matrix[row][col - 2].isMerged && !matrix[row][col - 1].isMerged {
                        matrix[row][col - 2].number += matrix[row][col - 1].number
                        matrix[row][col - 2].oldPositionMerged = matrix[row][col - 2].oldPosition
                        updateOldPosition(&matrix[row][col - 2], matrix[row][col - 1])
                        checkMaxTile(matrix[row][col - 2].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                        matrix[row][col - 1].number = 0
                        score += matrix[row][col - 2].number
                        updateBestScore()
                    }
                    if col - 1 > 0 && matrix[row][col - 2].number == 0 {
                        matrix[row][col - 2].number = matrix[row][col - 1].number
                        updateOldPosition(&matrix[row][col - 2], matrix[row][col - 1])
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
                    updateOldPosition(&matrix[row][col], matrix[row][col - 1])
                    matrix[row][col - 1].number = 0
                }
                if col < matrix.count - 1 && matrix[row][col].number == matrix[row][col + 1].number { //if my next element and my current element are the same, I have to add them and put on my next element's index
                    matrix[row][col + 1].number += matrix[row][col].number
                    matrix[row][col + 1].oldPositionMerged = matrix[row][col + 1].oldPosition
                    updateOldPosition(&matrix[row][col + 1], matrix[row][col])
                    matrix[row][col].number = 0
                    matrix[row][col + 1].isMerged = true
                    checkMaxTile(matrix[row][col + 1].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                    score += matrix[row][col + 1].number
                    updateBestScore()
                }
                if col < matrix.count - 1 && matrix[row][col + 1].number == 0 { //if my previous element is 0, I am bringing my current element under my next element's index
                    matrix[row][col + 1].number = matrix[row][col].number
                    updateOldPosition(&matrix[row][col + 1], matrix[row][col])
                    matrix[row][col].number = 0
                    if col + 1 < matrix.count - 1 && matrix[row][col + 2].number == matrix[row][col + 1].number && !matrix[row][col + 2].isMerged && !matrix[row][col + 1].isMerged {
                        matrix[row][col + 2].number += matrix[row][col + 1].number
                        matrix[row][col + 2].oldPositionMerged = matrix[row][col + 2].oldPosition
                        updateOldPosition(&matrix[row][col + 2], matrix[row][col + 1])
                        checkMaxTile(matrix[row][col + 2].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                        matrix[row][col + 1].number = 0
                        score += matrix[row][col + 2].number
                        updateBestScore()
                    }
                    if col + 2 < matrix.count && matrix[row][col + 2].number == 0 {
                        matrix[row][col + 2].number = matrix[row][col + 1].number
                        updateOldPosition(&matrix[row][col + 2], matrix[row][col + 1])
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
                    updateOldPosition(&matrix[row][col], matrix[row + 1][col])
                    matrix[row + 1][col].number = 0
                }
                if row > 0 && matrix[row - 1][col].number == matrix[row][col].number { //checking if my previous element is equal to my current element, adding them and setting to previous element's place
                    matrix[row - 1][col].number += matrix[row][col].number
                    matrix[row - 1][col].oldPositionMerged = matrix[row - 1][col].oldPosition
                    updateOldPosition(&matrix[row - 1][col], matrix[row][col])
                    matrix[row][col].number = 0
                    matrix[row - 1][col].isMerged = true
                    checkMaxTile(matrix[row - 1][col].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                    score += matrix[row - 1][col].number
                    updateBestScore()
                }
                if row > 0 && matrix[row - 1][col].number == 0 { //checking if my previous element is 0, and switching their places
                    matrix[row - 1][col].number = matrix[row][col].number
                    updateOldPosition(&matrix[row - 1][col], matrix[row][col])
                    matrix[row][col].number = 0
                    if row - 1 > 0 && matrix[row - 2][col].number == matrix[row - 1][col].number && !matrix[row - 2][col].isMerged && !matrix[row - 1][col].isMerged {
                        matrix[row - 2][col].number += matrix[row - 1][col].number
                        matrix[row - 2][col].oldPositionMerged = matrix[row - 2][col].oldPosition
                        updateOldPosition(&matrix[row - 2][col], matrix[row - 1][col])
                        checkMaxTile(matrix[row - 2][col].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                        matrix[row - 1][col].number = 0
                        score += matrix[row - 2][col].number
                        updateBestScore()
                    }
                    if row - 1 > 0 && matrix[row - 2][col].number == 0 {
                        matrix[row - 2][col].number = matrix[row - 1][col].number
                        updateOldPosition(&matrix[row - 2][col], matrix[row - 1][col])
                        matrix[row - 1][col].number = 0
                    }
                }
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
                    updateOldPosition(&matrix[row][col], matrix[row - 1][col])
                    matrix[row - 1][col].number = 0
                }
                if row < matrix.count - 1 && matrix[row + 1][col].number == matrix[row][col].number { // checking if my current element is equal to my next one, I am adding those numbers and put them into my element
                    matrix[row + 1][col].number += matrix[row][col].number
                    matrix[row + 1][col].oldPositionMerged = matrix[row + 1][col].oldPosition
                    updateOldPosition(&matrix[row + 1][col], matrix[row][col])
                    matrix[row][col].number = 0
                    matrix[row + 1][col].isMerged = true
                    checkMaxTile(matrix[row + 1][col].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                    score += matrix[row + 1][col].number
                    updateBestScore()
                }
                if row < matrix.count - 1 && matrix[row + 1][col].number == 0 { // checking if my next element is 0, I switch my current element with the next one
                    matrix[row + 1][col].number = matrix[row][col].number
                    updateOldPosition(&matrix[row + 1][col], matrix[row][col])
                    matrix[row][col].number = 0
                    if row + 1 < matrix.count - 1 && matrix[row + 2][col].number == matrix[row + 1][col].number && !matrix[row + 2][col].isMerged && !matrix[row + 1][col].isMerged {
                        matrix[row + 2][col].number += matrix[row + 1][col].number
                        matrix[row + 2][col].oldPositionMerged = matrix[row + 2][col].oldPosition
                        updateOldPosition(&matrix[row + 2][col], matrix[row + 1][col])
                        matrix[row + 1][col].number = 0
                        checkMaxTile(matrix[row + 2][col].number) //checks if the merged block with its new value is higher than the max tile, and if it is so, it changes the max value the this new value
                        score += matrix[row + 2][col].number
                        updateBestScore()
                    }
                    if row + 2 < matrix.count && matrix[row + 2][col].number == 0 {
                        matrix[row + 2][col].number = matrix[row + 1][col].number
                        updateOldPosition(&matrix[row + 2][col], matrix[row + 1][col])
                        matrix[row + 1][col].number = 0
                    }
                }
            }
        }
    }
    
    //MARK: - Saving Algorithm
    func save() {  //keeping our matrix and best score in UserDefaults, so that when I kill my app and go back to it, I can have access on the matrix and best score
        savedMatrix = matrix//saving the matrix
        let encoderForMatrix = JSONEncoder()
        if let data = try? encoderForMatrix.encode(savedMatrix) {
            UserDefaults.standard.set(data, forKey: "savedMatrix")
        }
        encodeFor("savedBestScore", bestScore)//saving the best score
        encodeFor("CurrentScore", score)//saving the current score
        encodeFor("MaxTile", maxTile)//saving the max tile
    }
    
    func retrieveSaved() {//this is the backwards process, I retrieve my saved matrix and best score
        //for matrix
        if let data = UserDefaults.standard.data(forKey: "savedMatrix"),
           let decodedArray = try? JSONDecoder().decode([[Blocks]].self, from: data) {
            retrievedMatrix = decodedArray
            matrix = retrievedMatrix
        }
        decoderFor("savedBestScore", &bestScore)// for the best score
        decoderFor("CurrentScore", &score) //for the current score
        decoderFor("MaxTile", &maxTile)//for the max tile
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
    func checkMaxTile(_ number: Int) {//checking the highest Tile
        if maxTile < number {
            maxTile = number
        }
    }
    
    func updateOldPosition(_ block1: inout Blocks, _ block2: Blocks) {
        block1.oldPosition = block2.oldPosition
    }
    
    func updateMerged() { //helper function to update my isMerged property after doing the addition
        for row in 0...matrix.count - 1 {
            for col in 0...matrix.count - 1 {
                matrix[row][col].isMerged = false
                matrix[row][col].oldPosition = Position(row: row, col: col)
                matrix[row][col].oldPositionMerged = nil
            }
        }
    }
    
    func hasChanged(matrix: [[Blocks]]) -> Bool { //helper function to understand has my matrix changed or no
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
    
    func updateBestScore() { //helper method to update the best score if needed
        if score >= bestScore {
            bestScore = score
        }
    }
    
    func decoderFor(_ file: String, _ encoding: inout Int) { //Helper method to decode data
        if let data = UserDefaults.standard.data(forKey: file),
           let decoder = try? JSONDecoder().decode(Int.self, from: data) {
            encoding = decoder
        }
    }
    
    func encodeFor(_ file: String, _ encoding: Int) { //Helper method to encode data
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(encoding) {
            UserDefaults.standard.set(data, forKey: file)
        }
    }
    
    func createCopyMatrix() { //helper method to create copy of my matrix at exact moment
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
    
    func needToTerminate() -> Bool { //checks if the user lost the game or not(the matrix is full...)
        for row in 0..<matrix.count { // Check for horizontal (right) neighbors
            for col in 0..<matrix.count - 1 {
                if matrix[row][col].number == matrix[row][col + 1].number {
                    return false
                }
            }
        }
        
        for col in 0..<matrix.count { // Check for vertical (below) neighbors
            for row in 0..<matrix.count - 1 {
                if matrix[row][col].number == matrix[row + 1][col].number {
                    return false
                }
            }
        }
        return true
    }
}



