//
//  UIGameBoard.swift
//  GameProject2048
//
//  Created by Anna Hakobyan on 27.09.23.
//

import UIKit

final class UIGameBoardController: UIViewController {
    @IBOutlet weak var board: UIView!
    @IBOutlet weak var bestScore: UILabel!
    @IBOutlet weak var currentScore: UILabel!
    
    //for drawing a matrix on the board
    private let columns = 4
    private let rows = 4
    private let spacing: CGFloat = 10.0
    private var gameMatrix: [[BlockView]]!
    var backgroundMatrix: [[UIView]] = []
    
    ///////////
    var matrix = RandomBlocksModel()
    
    //for knowing which block is the user's highest, to not let generate a block higher then the current target
//    private var targetBlock: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMatrixBackground()
        createMatrix()
//        targetBlock = 2
        
        matrix.generateNewNumberForMatrix()
        matrix.generateNewNumberForMatrix()

        updateMatrix()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupBackground()
        setupMainMatrix()
    }
    
    //creating background for the main matrix
    func createMatrixBackground() {
        for _ in 0..<rows {
            var rowArray: [UIView] = []
            for _ in 0..<columns  {
                let block = UIView()
                block.backgroundColor = .white.withAlphaComponent(0.5)
                board.addSubview(block)
                rowArray.append(block)
            }
            backgroundMatrix.append(rowArray)
        }
    }
    
    //giving coordinates to each blockView, it is a common function to call for any matrix we want
    func setupMatrix(matrix: [[UIView]]) {
        let spacingWidth = spacing * CGFloat(columns + 1)
        let spacingHeight = spacing * CGFloat(rows + 1)
        let blockWidth = (board.bounds.width - spacingWidth) / CGFloat(columns)
        let blockHeight = (board.bounds.height - spacingHeight) / CGFloat(rows)
        
        for row in 0..<rows {
            for column in 0..<columns  {
                let x = CGFloat(column) * (blockWidth + spacing)
                let y = CGFloat(row) * (blockHeight + spacing)
                let block = matrix[row][column]
                block.frame = CGRect(x: spacing + x, y: spacing + y, width: blockWidth, height: blockHeight)
            }
        }
    }
    
    func setupBackground() {
        setupMatrix(matrix: backgroundMatrix)
    }
    
    func setupMainMatrix() {
        setupMatrix(matrix: gameMatrix)
    }
    
    
    func createMatrix() {
        gameMatrix = []
        for _ in 0..<rows {
            var rowrray: [BlockView] = []
            for _ in 0..<columns  {
                let block = BlockView()
//                if let image = UIImage(named: "2") {
//                    block.image.image = image
//                }
                board.addSubview(block)
                rowrray.append(block)
            }
            gameMatrix.append(rowrray)
        }
    }
    
    func updateMatrix() {
//        matrix.generateNewNumberForMatrix()
        for row in 0..<rows {
            for col in 0..<columns  {
                if matrix.matrixX[row][col] != 0 {
                    let block = gameMatrix[row][col]
                    if let image = UIImage(named: "\(matrix.matrixX[row][col])") {
                        block.image.image = image
                    }
                    gameMatrix[row][col] = block
                }
            }
        }
    }
    
}
