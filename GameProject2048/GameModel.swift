//
//  GameModel.swift
//  GameProject2048
//
//  Created by Milena Mirumyan on 25.09.23.
//

import Foundation

struct Block{
    var number: Int
    var id: (number: Int, isMerged: Bool)
}

final class GameModel{
    
    private var matrix: [[Block]] = []
    private var score: Int = 0 // the logic behind the score parameter is that when I merge two numbers my score is being incremented by the number I got, i.e. 4+4 = 8, my score will be incremented by 8 c
    private var savedMatrix: [[Block]]?
    
    init() {
        matrix = [
            [Block(number: 0, id: (0, false)), Block(number: 2, id: (2, false)), Block(number: 4, id: (4, false)), Block(number: 2, id: (2, false))],
            [Block(number: 4, id: (4, false)), Block(number: 8, id: (8, false)), Block(number: 2, id: (2, false)), Block(number: 4, id: (4, false))],
            [Block(number: 2, id: (2, false)), Block(number: 2, id: (2, false)), Block(number: 0, id: (0, false)), Block(number: 0, id: (0, false))],
            [Block(number: 2, id: (2, false)), Block(number: 4, id: (4, false)), Block(number: 4, id: (4, false)), Block(number: 2, id: (2, false))]
        ]
    }
  
    func additionLeft(){
        for row in 0...matrix.count-1{
            for col in 0...matrix.count-1{
                if matrix[row][col].number == 0 && col < matrix.count - 1 { //if my current element is 0, I have to switch it with my next element
                    matrix[row][col] = matrix[row][col+1]
                    matrix[row][col + 1].number = 0
                }
                if col > 0 && matrix[row][col - 1].number == matrix[row][col].number{ //if my previous element and my current element are the same, I have to add them and put on my previous element's index
                    matrix[row][col - 1].number += matrix[row][col].number
                    matrix[row][col].number = 0
                    score += matrix[row][col - 1].number
                }
                if col > 0 && matrix[row][col - 1].number == 0{ //if my previous element is 0, I am bringing my current element to my previous element's place
                    matrix[row][col - 1].number = matrix[row][col].number
                    matrix[row][col].number = 0
                }
            }
        }
    }
        
    func additionRight(){
        for row in 0...matrix.count - 1{
            for col in stride(from: matrix.count-1, to: 0, by: -1){ //if my current element is 0, I have to switch it with my previous element
                if col > 0 && matrix[row][col].number == 0{
                    matrix[row][col].number = matrix[row][col - 1].number
                    matrix[row][col - 1].number = 0
                }
                if col < matrix.count - 1 && matrix[row][col].number == matrix[row][col + 1].number{ //if my next element and my current element are the same, I have to add them and put on my next element's index
                    matrix[row][col + 1].number += matrix[row][col].number
                    matrix[row][col].number = 0
                    score += matrix[row][col + 1].number
                }
                if col < matrix.count - 1 && matrix[row][col + 1].number == 0{ //if my previous element is 0, I am bringing my current element under my next element's index
                    matrix[row][col + 1].number = matrix[row][col].number
                    matrix[row][col].number = 0
                }
            }
        }
    }
    
    func additionTop(){
        for col in 0...matrix.count - 1 { // going over the columns
            for row in 0...matrix.count - 1 {   //going over the rows
                if matrix[row][col].number == 0 && row < matrix.count - 1 { //checking if my current element is 0 and if it is, I have to change my next row number to my current one
                    matrix[row][col].number = matrix[row + 1][col].number
                    matrix[row + 1][col].number = 0
                }
                if row > 0 && matrix[row - 1][col].number == matrix[row][col].number { //checking if my previous element is equal to my current element, adding them and setting to previous element's place
                    matrix[row - 1][col].number += matrix[row][col].number
                    matrix[row][col].number = 0
                    score += matrix[row - 1][col].number
                }
                if row > 0 && matrix[row - 1][col].number == 0 { //checking if my previous element is 0, and switching their places
                    matrix[row - 1][col].number = matrix[row][col].number
                    matrix[row][col].number = 0
                } //thus, I covered all the possible cases
            }
        }
    }
    
    func additionBottom(){
        for col in 0...matrix.count-1{  //going over the columns
            for row in stride(from: matrix.count-1, to: 0, by: -1){ //going over the rows
                if matrix[row][col].number == 0 && row > 0{ // checking if my current element is 0, and switching it with the previous one
                    matrix[row][col].number = matrix[row - 1][col].number
                    matrix[row - 1][col].number = 0
                }
                if row < matrix.count - 1 && matrix[row + 1][col].number == matrix[row][col].number { // checking if my current element is equal to my next one, I am adding those numbers and put them into my element
                    matrix[row][col].number += matrix[row+1][col].number
                    matrix[row+1][col].number = 0
                    score += matrix[row][col].number
                }
                if row < matrix.count - 1 && matrix[row+1][col].number == 0{ // checking if my next element is 0, I switch my current element with the next one
                    matrix[row + 1][col].number = matrix[row][col].number
                    matrix[row][col].number = 0
                }
                
            }
        }
    }
     
    //MARK: - Deletable
    func test(){
        additionBottom()
        for i in matrix.indices{
            for j in matrix.indices{
                print(matrix[i][j].number)
            }
            print(" ")
        }
    }
    
    //MARK: - Saving Algorithm
    func save(){
        savedMatrix = matrix
    }
}
    
