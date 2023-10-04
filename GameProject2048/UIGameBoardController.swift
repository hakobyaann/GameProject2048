//
//  UIGameBoard.swift
//  GameProject2048
//
//  Created by Anna Hakobyan on 27.09.23.
//

import UIKit

final class UIGameBoardController: UIViewController {
    @IBOutlet weak var board: UIView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var bestScore: UILabel!
    @IBOutlet weak var currentScore: UILabel!
    @IBOutlet weak var mainView: UIView!
    var menuBar: UIView? = nil
    
    //for drawing a matrix on the board
    private let columns = 4
    private let rows = 4
    private let spacing: CGFloat = 10.0
    private var gameMatrix: [[BlockView]]!
    var backgroundMatrix: [[UIView]] = []
    
    var matrix = RandomBlocksModel()
    
    //for knowing which block is the user's highest, to not let generate a block higher then the current target
//    private var targetBlock: Int?
    
    @IBAction func menu(_ sender: Any) {
        createMenuBar()
    }
    
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
    
    // Create the overlay view with buttons
    func createMenuBar() {
        let overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5) // Semi-transparent background color
        self.view.addSubview(overlayView)
        // Create buttons
        let buttons = createButtons()
        overlayView.addSubview(buttons)
        buttons.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            buttons.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            buttons.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            // You can add more constraints as needed to position the stack view vertically.
        ])
        buttons.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        buttons.clipsToBounds = false
        menuBar = overlayView
        
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
    
    // Create an array of buttons
    func createButtons() -> UIStackView {
        let restartButton = UIButton(type: .system)
        let homeButton = UIButton(type: .system)
        let playButton = UIButton(type: .system)
        
        if let imageHome = UIImage(named: "home") {
            homeButton.setImage(imageHome.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        if let imageRestart = UIImage(named: "restart") {
            restartButton.setImage(imageRestart.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        if let imagePlay = UIImage(named: "play") {
            playButton.setImage(imagePlay.withRenderingMode(.alwaysOriginal), for: .normal)
        }
            let buttonSize: CGFloat = 100.0
            
        
            restartButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
                restartButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true

                homeButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
                homeButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true

                playButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
                playButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        let buttons = UIStackView()
        buttons.axis = .horizontal
        buttons.alignment = .fill
        buttons.distribution = .fillEqually
        buttons.spacing = 20
        print("Hi")
        buttons.addArrangedSubview(restartButton)
        buttons.addArrangedSubview(homeButton)
        buttons.addArrangedSubview(playButton)
            restartButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            restartButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

            homeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            homeButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

            playButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
            playButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        playButton.addTarget(self, action: #selector(continuePlaying), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(dismissing), for: .touchUpInside)
        restartButton.addTarget(self, action: #selector(restarting), for: .touchUpInside)
        
        return buttons
    }
    
    // playButton tap action
    @objc func continuePlaying(_ sender: UIButton) {
        if let view = menuBar {
            view.removeFromSuperview()
        }
    }
    //homeButton tap action
    @objc func dismissing(_ sender: UIButton) {
        //savingalgorythm()
        self.navigationController?.popViewController(animated: true)
    }
    
    //restartButton tap action
    @objc func restarting(_ sender: UIButton) {
        for row in 0..<rows {
            for col in 0..<columns  {
                if matrix.matrixX[row][col] != 0 {
                    matrix.matrixX[row][col] = 0
                }
                gameMatrix[row][col].image.image = nil
                print(matrix.matrixX[row][col])

            }
            print()
        }
        print("after restarting")
        updateMatrix()
        matrix.generateNewNumberForMatrix()
        matrix.generateNewNumberForMatrix()
        updateMatrix()
        if let view = menuBar {
            view.removeFromSuperview()
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
                board.addSubview(block)
                rowrray.append(block)
            }
            gameMatrix.append(rowrray)
        }
    }
    
    func updateMatrix() {
        for row in 0..<rows {
            for col in 0..<columns  {
                if matrix.matrixX[row][col] != 0 {
                    let block = gameMatrix[row][col]
                    if let image = UIImage(named: "\(matrix.matrixX[row][col])") {
                        block.image.image = image
                    }
                    gameMatrix[row][col] = block
                    print(matrix.matrixX[row][col])
                }
                print()
            }
        }
    }
    
}
