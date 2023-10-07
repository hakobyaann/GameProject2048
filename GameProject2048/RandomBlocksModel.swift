////
////  RandomBlocksModel.swift
////  GameProject2048
////
////  Created by Anna Hakobyan on 30.09.23.
////
//
//import Foundation
//
//
//final class RandomBlocksModel {
//    
//    var emptyCoordinates: [(Int, Int)] = [] // array for empty coordinates
//    var matrixX: [[Int]] = []
//    private var target: Int?
//    
//    init() {
//        target = 2
//        matrixX = [
//            [0, 0, 0, 0],
//            [0, 0, 0, 0],
//            [0, 0, 0, 0],
//            [0, 0, 0, 0]
//        ]
//    }
//    
//    func generateRandomCoordinates() {
//        for rowIndex in 0..<matrixX.count {
//            for columnIndex in 0..<matrixX[rowIndex].count {
//                if matrixX[rowIndex][columnIndex] == 0 {
//                    emptyCoordinates.append((rowIndex, columnIndex))
//                }
//            }
//        }
//        // if there is no any empty coordinate function must terminate it's work
//        guard !emptyCoordinates.isEmpty else {
//            return
//        }
//    }
//    
//    func generateRandomNumber() -> Int {
//        let minExponent = 1 // Minimum exponent (2^1 = 2)
////        let maxExponent = 11 // Maximum exponent (2^11 = 2048)
//
//        let randomExponent = Int.random(in: minExponent...target! - 1) //random exponent for generating the final random number which will be the power of 2
//        
//        return Int(pow(2.0, Double(randomExponent))) //returning the final number which is already a power of 2
//    }
//    
//    func generateNewNumberForMatrix() {
//        let number = generateRandomNumber()
//        generateRandomCoordinates() //emptyCoordinates
//        
//        //generate random index within empty coordinates in matrix
//        let randomIndex = Int.random(in: 0..<emptyCoordinates.count)
//        let (row, column) = emptyCoordinates[randomIndex] //picking the coordinates
//        
//        //adding the number into matrix
//        matrixX[row][column] = number
//        emptyCoordinates.remove(at: randomIndex) //removing its coordinates since it is not empty
//        
//    }
//    
//    func test() {
//        generateNewNumberForMatrix()
//        for i in matrixX.indices {
//            for j in matrixX.indices {
//                print(matrixX[i][j], terminator: " ")
//            }
//            print()
//        }
//        print()
//    }
//}
//
//// we should take into count that every time when swiping the numbers we should update the emptycoordinates becuase it changes every time!!!
//// and also to not let numbers higher than our current target appear in matrix !!!
