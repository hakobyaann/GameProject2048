//
//  UIKeepGoingController.swift
//  GameProject2048
//
//  Created by Milena Mirumyan on 09.10.23.
//

import UIKit

final class KeepGoingController: UIViewController {
    let rows = 4
    let columns = 4
    @IBOutlet weak var keepBoard: UIView!
    var keepBackgroundMatrix: [[UIView]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMatrixBackground()
    }
    
    func createMatrixBackground() {
        for _ in 0..<rows {
            var rowArray: [UIView] = []
            for _ in 0..<columns  {
                let block = UIView()
                block.backgroundColor = .white.withAlphaComponent(0.5)
                keepBoard.addSubview(block)
                rowArray.append(block)
            }
            keepBackgroundMatrix.append(rowArray)
        }
    }
}
