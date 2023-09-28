//
//  GameModel.swift
//  GameProject2048
//
//  Created by Milena Mirumyan on 25.09.23.
//

import Foundation

final class GameModel{
    private var matrix = [[Int]]()
    private var leftMost = [Int]() //this leftMost array is used to identify the leftmost elements in array
    private var rightMost = [Int]()
    private var topMost = [Int]()
    private var bottomMost = [Int]()
    
    
    
    func generatingArraysForAddition() {
        for i in matrix {          //filling leftMost and rightMost arrays
            if i.isEmpty == true{  //if that row is empty it means we don't have leftMost or rightMost elements, so we need to add 0 in the array to                           somehow show that
                leftMost.append(0)
                rightMost.append(0)
            }else{
                for j in i{            //we are appending our leftMost by thef irst ever element that is not 0(means is present)
                    if j != 0 {
                        leftMost.append(j)
                        return
                    }
                }
                for k in stride(from: i.count-1, to: 0, by: 1){ //we are appending our rightMost by the first ever element from right that is not 0(means is present), but we need to check that if it is the same as leftMost element, we shouldn't update our leftMost element
                    if k != 0 && k != leftMost[leftMost.count-1]{    //we should compare it with out last element that we recently added to leftMost
                        rightMost.append(k)
                        return
                    }else if k == leftMost[leftMost.count-1]{
                        rightMost.append(0)
                    }
                }
            }
            
        }
        
       
        
    }
    
    
    func addition(){
        
    }
    
    
    
    
}
