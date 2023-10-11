//
//  GameModel.swift
//  GameProject2048
//
//  Created by Milena Mirumyan on 25.09.23.
//

import Foundation

struct Blocks: Codable{
    var isMerged: Bool
    var number: Int
    
}


final class GameModel{
    
    var matrix: [[Blocks]] = []
    var score: Int = 0 // the logic behind the score parameter is that when I merge two numbers my score is being incremented by the number I got, i.e. 4+4 = 8, my score will be incremented by 8 c
    var savedMatrix: [[Blocks]] = []
    var emptyCoordinates: [(Int, Int)] = [] // array for empty coordinates
    private var target: Int = 2
    private var matrixCopy: [[Blocks]] = []
    var retrievedMatrix: [[Blocks]] = []
    
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
    func additionLeft(){
        createCopyMatrix()
        for row in 0...matrix.count-1{
            for col in 0...matrix.count-1{
                if matrix[row][col].number == 0 && col < matrix.count - 1 { //if my current element is 0, I have to switch it with my next element
                    matrix[row][col].number = matrix[row][col+1].number
                    matrix[row][col + 1].number = 0
                }
                if col > 0 && matrix[row][col - 1].number == matrix[row][col].number{ //if my previous element and my current element are the same, I have to add them and put on my previous element's index
                    matrix[row][col - 1].number += matrix[row][col].number
                    matrix[row][col].number = 0
                    matrix[row][col - 1].isMerged = true
                    score += matrix[row][col - 1].number
                }
                if col > 0 && matrix[row][col - 1].number == 0{ //if my previous element is 0, I am bringing my current element to my previous element's place
                    matrix[row][col - 1].number = matrix[row][col].number
                    matrix[row][col].number = 0
                    if col - 1 > 0 && matrix[row][col - 2].number == matrix[row][col - 1].number && !matrix[row][col - 2].isMerged && !matrix[row][col - 1].isMerged {
                        matrix[row][col - 2].number += matrix[row][col - 1].number
                        matrix[row][col - 1].number = 0
                        score += matrix[row][col - 2].number
                    }
                    if col - 1 > 0 && matrix[row][col - 2].number == 0{
                        matrix[row][col - 2].number = matrix[row][col - 1].number
                        matrix[row][col - 1].number = 0
                    }
                }
            }
        }
        updateMerged()
        if hasChanged(matrix: matrix){  //if adding to the left my matrix doesn't change I should not generate new random number
            generateNewNumberForMatrix()
        }
    }
    
    //MARK: - Addition Right
    func additionRight(){
        createCopyMatrix()
        for row in 0...matrix.count - 1{
            for col in stride(from: matrix.count-1, to: -1, by: -1){ //if my current element is 0, I have to switch it with my previous element
                if col > 0 && matrix[row][col].number == 0{
                    matrix[row][col].number = matrix[row][col - 1].number
                    matrix[row][col - 1].number = 0
                }
                if col < matrix.count - 1 && matrix[row][col].number == matrix[row][col + 1].number{ //if my next element and my current element are the same, I have to add them and put on my next element's index
                    matrix[row][col + 1].number += matrix[row][col].number
                    matrix[row][col].number = 0
                    matrix[row][col + 1].isMerged = true
                    score += matrix[row][col + 1].number
                }
                if col < matrix.count - 1 && matrix[row][col + 1].number == 0{ //if my previous element is 0, I am bringing my current element under my next element's index
                    matrix[row][col + 1].number = matrix[row][col].number
                    matrix[row][col].number = 0
                    if col + 1 < matrix.count - 1 && matrix[row][col + 2].number == matrix[row][col + 1].number && !matrix[row][col + 2].isMerged && !matrix[row][col + 1].isMerged{
                        matrix[row][col + 2].number += matrix[row][col + 1].number
                        matrix[row][col + 1].number = 0
                        score += matrix[row][col + 2].number
                    }
                    if col + 2 < matrix.count && matrix[row][col + 2].number == 0{
                        matrix[row][col + 2].number = matrix[row][col + 1].number
                        matrix[row][col + 1].number = 0
                    }
                }
            }
        }
        updateMerged()
        if hasChanged(matrix: matrix){ //if adding to the right my matrix doesn't change I should not generate new random number
            generateNewNumberForMatrix()
        }
    }
    
    //MARK: - Addition Top
    func additionTop(){
        createCopyMatrix()
        for col in 0...matrix.count - 1 { // going over the columns
            for row in 0...matrix.count - 1 {   //going over the rows
                if matrix[row][col].number == 0 && row < matrix.count - 1 { //checking if my current element is 0 and if it is, I have to change my next row number to my current one
                    matrix[row][col].number = matrix[row + 1][col].number
                    matrix[row + 1][col].number = 0
                }
                if row > 0 && matrix[row - 1][col].number == matrix[row][col].number { //checking if my previous element is equal to my current element, adding them and setting to previous element's place
                    matrix[row - 1][col].number += matrix[row][col].number
                    matrix[row][col].number = 0
                    matrix[row - 1][col].isMerged = true
                    score += matrix[row - 1][col].number
                }
                if row > 0 && matrix[row - 1][col].number == 0 { //checking if my previous element is 0, and switching their places
                    matrix[row - 1][col].number = matrix[row][col].number
                    matrix[row][col].number = 0
                    if row - 1 > 0 && matrix[row-2][col].number == matrix[row - 1][col].number && !matrix[row-2][col].isMerged && !matrix[row - 1][col].isMerged{
                        matrix[row - 2][col].number += matrix[row - 1][col].number
                        matrix[row - 1][col].number = 0
                        score += matrix[row - 2][col].number
                    }
                    if row - 1 > 0 && matrix[row - 2][col].number == 0{
                        matrix[row - 2][col].number = matrix[row - 1][col].number
                        matrix[row - 1][col].number = 0
                        
                    }
                } //thus, I covered all the possible cases
            }
        }
        updateMerged()
        if hasChanged(matrix: matrix){  //if adding to the top my matrix doesn't change I should not generate new random number
            generateNewNumberForMatrix()
        }
    }
    
    //MARK: - Addition Bottom
    func additionBottom(){
        createCopyMatrix()
        for col in 0...matrix.count-1{  //going over the columns
            for row in stride(from: matrix.count-1, to: -1, by: -1){ //going over the rows
                if matrix[row][col].number == 0 && row > 0{ // checking if my current element is 0, and switching it with the previous one
                    matrix[row][col].number = matrix[row - 1][col].number
                    matrix[row - 1][col].number = 0
                }
                if row < matrix.count - 1 && matrix[row + 1][col].number == matrix[row][col].number { // checking if my current element is equal to my next one, I am adding those numbers and put them into my element
                    matrix[row + 1][col].number += matrix[row][col].number
                    matrix[row][col].number = 0
                    matrix[row + 1][col].isMerged = true
                    score += matrix[row + 1][col].number
                }
                if row < matrix.count - 1 && matrix[row + 1][col].number == 0{ // checking if my next element is 0, I switch my current element with the next one
                    matrix[row + 1][col].number = matrix[row][col].number
                    matrix[row][col].number = 0
                    if row + 1 < matrix.count - 1 && matrix[row + 2][col].number == matrix[row + 1][col].number && !matrix[row + 2][col].isMerged && !matrix[row + 1][col].isMerged{
                        matrix[row + 2][col].number += matrix[row + 1][col].number
                        matrix[row + 1][col].number = 0
                        score += matrix[row + 2][col].number
                    }
                    if row + 2 < matrix.count && matrix[row + 2][col].number == 0{
                        matrix[row + 2][col].number = matrix[row + 1][col].number
                        matrix[row + 1][col].number = 0
                        
                    }
                }
                
            }
        }
        updateMerged()
        if hasChanged(matrix: matrix){  //if adding to the bottom my matrix doesn't change I should not generate new random number
            generateNewNumberForMatrix()
        }
    }
    
    
    //MARK: - Saving Algorithm
    func save(){  //keeping our matrix in UserDefaults, so that when I kill my app and go back to it, I can access my saved matrix
        savedMatrix = matrix
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(savedMatrix) {
            UserDefaults.standard.set(data, forKey: "savedMatrix")
        }
    }
    
    func retrieveSaved() {    //this is the backwards process, I retrieve my saved matrix
        if let data = UserDefaults.standard.data(forKey: "savedMatrix"),
            let decodedArray = try? JSONDecoder().decode([[Blocks]].self, from: data) {
            retrievedMatrix = decodedArray
            matrix = retrievedMatrix
        }
    }
    
    //MARK: - Generating random number at random empty coordinate
    func generateRandomCoordinates() {
        for rowIndex in 0..<matrix.count {
            for columnIndex in 0..<matrix[rowIndex].count {
                if matrix[rowIndex][columnIndex].number == 0 {
                    emptyCoordinates.append((rowIndex, columnIndex))
                }
            }
        }
        guard !emptyCoordinates.isEmpty else {
            return
        }
    }
    
    func generateNewNumberForMatrix() {
        let number = 2 * Int.random(in: 1...2)
        generateRandomCoordinates() //emptyCoordinates
        
        //generate random index within empty coordinates in matrix
        let randomIndex = Int.random(in: 0..<emptyCoordinates.count)
        let (row, column) = emptyCoordinates[randomIndex] //picking the coordinates
        
        //adding the number into matrix
        matrix[row][column].number = number
        emptyCoordinates = [] //removing its coordinates since it is not empty
        
    }
    
    //MARK: Helper Methods
    func updateMerged(){    //helper function to update my isMerged property after doing the addition
        for row in 0...matrix.count - 1{
            for col in 0...matrix.count - 1{
                matrix[row][col].isMerged = false
            }
        }
    }
    
    func hasChanged(matrix: [[Blocks]]) -> Bool{    // helper function to understand has my matrix changed or no
        var answer = false
        for row in 0...matrix.count - 1{
            for col in 0...matrix.count - 1{
                if matrix[row][col].number != matrixCopy[row][col].number{
                    answer = true
                }
            }
        }
        return answer
    }
    
    func createCopyMatrix(){    //helper method to create copy of my matrix at exact moment
        for row in 0...matrix.count - 1{
            for col in 0...matrix.count - 1{
                matrixCopy[row][col] = matrix[row][col]
            }
        }
    }
    
    func checking() -> Bool {
            for col in 0..<matrix.count {
                for row in 1..<matrix.count - 1 {
                    if matrix[col][row].number != matrix[col][row + 1].number {
                        return false
                    }
                }
                for col in 0..<matrix.count - 1{
                    for row in 1..<matrix.count {
                        if matrix[col][row].number != matrix[col][row + 1].number {
                            return false
                        }
                    }
                }
            }
            return true
        }

}



