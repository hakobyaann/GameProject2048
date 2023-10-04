//
//  GameModel.swift
//  GameProject2048
//
//  Created by Milena Mirumyan on 25.09.23.
//

import Foundation

final class GameModel{
    
    private var matrix: [[Int]] = []
    private var score: Int = 0 // the logic behind the score parameter is that when I merge two numbers my score is being incremented by the number I got, i.e. 4+4 = 8, my score will be incremented by 8 c
    private var savedMatrix: [[Int]]?
    
    init() {
        matrix = [
            [0,2,4,2],
            [4,8,2,4],
            [2,2,0,0],
            [2,4,4,2]
        ]
    }
  
    func additionLeft(){
        for row in 0...matrix.count-1{
            for col in 0...matrix.count-1{
                if matrix[row][col] == 0 && col < matrix.count - 1 { //if my current element is 0, I have to switch it with my next element
                    matrix[row][col] = matrix[row][col+1]
                    matrix[row][col + 1] = 0
                }
                if col > 0 && matrix[row][col - 1] == matrix[row][col]{ //if my previous element and my current element are the same, I have to add them and put on my previous element's index
                    matrix[row][col - 1] += matrix[row][col]
                    matrix[row][col] = 0
                    score += matrix[row][col - 1]
                }
                if col > 0 && matrix[row][col - 1] == 0{ //if my previous element is 0, I am bringing my current element to my previous element's place
                    matrix[row][col - 1] = matrix[row][col]
                    matrix[row][col] = 0
                }
            }
        }
    }
        
    func additionRight(){
        for row in 0...matrix.count - 1{
            for col in stride(from: matrix.count-1, to: 0, by: -1){ //if my current element is 0, I have to switch it with my previous element
                if col > 0 && matrix[row][col] == 0{
                    matrix[row][col] = matrix[row][col - 1]
                    matrix[row][col - 1] = 0
                }
                if col < matrix.count - 1 && matrix[row][col] == matrix[row][col + 1]{ //if my next element and my current element are the same, I have to add them and put on my next element's index
                    matrix[row][col + 1] += matrix[row][col]
                    matrix[row][col] = 0
                    score += matrix[row][col + 1]
                }
                if col < matrix.count - 1 && matrix[row][col + 1] == 0{ //if my previous element is 0, I am bringing my current element under my next element's index
                    matrix[row][col + 1] = matrix[row][col]
                    matrix[row][col] = 0
                }
            }
        }
    }
    
    func additionTop(){
        for col in 0...matrix.count - 1 { // going over the columns
            for row in 0...matrix.count - 1 {   //going over the rows
                if matrix[row][col] == 0 && row < matrix.count - 1 { //checking if my current element is 0 and if it is, I have to change my next row number to my current one
                    matrix[row][col] = matrix[row + 1][col]
                    matrix[row + 1][col] = 0
                }
                if row > 0 && matrix[row - 1][col] == matrix[row][col] { //checking if my previous element is equal to my current element, adding them and setting to previous element's place
                    matrix[row - 1][col] += matrix[row][col]
                    matrix[row][col] = 0
                    score += matrix[row - 1][col]
                }
                if row > 0 && matrix[row - 1][col] == 0 { //checking if my previous element is 0, and switching their places
                    matrix[row - 1][col] = matrix[row][col]
                    matrix[row][col] = 0
                } //thus, I covered all the possible cases
            }
        }
    }
    
    func additionBottom(){
        for col in 0...matrix.count-1{  //going over the columns
            for row in stride(from: matrix.count-1, to: 0, by: -1){ //going over the rows
                if matrix[row][col] == 0 && row > 0{ // checking if my current element is 0, and switching it with the previous one
                    matrix[row][col] = matrix[row - 1][col]
                    matrix[row - 1][col] = 0
                }
                if row < matrix.count - 1 && matrix[row + 1][col] == matrix[row][col] { // checking if my current element is equal to my next one, I am adding those numbers and put them into my element
                    matrix[row][col] += matrix[row+1][col]
                    matrix[row+1][col] = 0
                    score += matrix[row][col]
                }
                if row < matrix.count - 1 && matrix[row+1][col] == 0{ // checking if my next element is 0, I switch my current element with the next one
                    matrix[row + 1][col] = matrix[row][col]
                    matrix[row][col] = 0
                }
                
            }
        }
    }
     
    //MARK: - Deletable
    func test(){
        additionBottom()
        for i in matrix.indices{
            for j in matrix.indices{
                print(matrix[i][j])
            }
            print(" ")
        }
    }
    
    //MARK: - Saving Algorithm
    func save(){    //keeping our matrix in UserDefaults, so that when I kill my app and go back to it, I can access my saved matrix
        savedMatrix = matrix
        UserDefaults.standard.set(savedMatrix, forKey: "gameMatrix")
    }
    
    func retrieveSaved(){    //this is the backwards process, I retrieve my saved matrix
        if let savedMatrix = UserDefaults.standard.array(forKey: "gameMatrix") as? [[Int]]{
            let rows = savedMatrix.count
            let cols = savedMatrix.count
            var retrievedMatrix = Array(repeating: Array(repeating: 0, count: rows), count: cols)
            for row in 0...savedMatrix.count - 1{
                for col in 0...savedMatrix.count - 1{
                    retrievedMatrix[row][col] = savedMatrix[row][col]
                }
            }
        }
    }
}
    
