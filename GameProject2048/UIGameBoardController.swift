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
    
    //for drawing a matrix on the board
    private let columns = 4
    private let rows = 4
    private let spacing: CGFloat = 10.0
    private var gameMatrix: [[BlockView]]!
    var backgroundMatrix: [[UIView]] = []
    var gameModel = GameModel()
    var shouldKeepGoing: Bool = false
    var lostBar: UIView? = nil
    var winBar: UIView? = nil
    var menuBar: UIView? = nil
    
    @IBAction func menu(_ sender: Any) {
        createMenuBar()
    }
    
    func keepGoing() {
        gameModel.retrieveSaved()
        bestScore.text = "\(gameModel.bestScore)"
        currentScore.text = "\(gameModel.score)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMatrixBackground()
        createMatrix()
        
        if !shouldKeepGoing {
            gameModel.generateNewNumberForMatrix()
            gameModel.generateNewNumberForMatrix()
        }
        if shouldKeepGoing {
            keepGoing()
        }
        
        scoresTracking()
        updateMatrix()
        
        //swipeGestures
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        let swipeGestureUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        let swipeGestureDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        
        swipeGestureLeft.direction = .left
        swipeGestureRight.direction = .right
        swipeGestureUp.direction = .up
        swipeGestureDown.direction = .down
        
        board.addGestureRecognizer(swipeGestureLeft)
        board.addGestureRecognizer(swipeGestureRight)
        board.addGestureRecognizer(swipeGestureUp)
        board.addGestureRecognizer(swipeGestureDown)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleTermination),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    @objc func handleTermination() {
        gameModel.save()
    }
    
    func scoresTracking() {
        currentScore.text = "\(gameModel.score)"
        bestScore.text = "\(gameModel.bestScore)"
    }
    
    //MARK: functions for swiping/addition
    @objc func swipeLeft() {
        gameModel.additionLeft()
        scoresTracking()
        updateMatrix()
        
        //checking whether the game needs to be teminated or not (Lose! or continue)
        if gameModel.needToTerminate() && gameModel.emptyCoordinates.isEmpty {
            createLostBar()
        }
    }
    
    @objc func swipeRight() {
        gameModel.additionRight()
        scoresTracking()
        updateMatrix()
        //checking whether the game need to be teminated or not (Lose! or continue)
        if gameModel.needToTerminate() == true && gameModel.emptyCoordinates.count == 0 {
            createLostBar()
        }
    }
    
    @objc func swipeUp() {
        gameModel.additionTop()
        scoresTracking()
        updateMatrix()
        //checking whether the game need to be teminated or not (Lose! or continue)
        if gameModel.needToTerminate() == true && gameModel.emptyCoordinates.count == 0 {
            createLostBar()
        }
    }
    
    @objc func swipeDown() {
        gameModel.additionBottom()
        scoresTracking()
        updateMatrix()
        //checking whether the game need to be teminated or not (Lose! or continue)
        if gameModel.needToTerminate() == true && gameModel.emptyCoordinates.count == 0 {
            createLostBar()
        }

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
            for _ in 0..<columns {
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
            for column in 0..<columns {
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
        gameModel.save()
        self.navigationController?.popViewController(animated: true)
    }
    
    //restartButton tap action
    @objc func restarting(_ sender: UIButton) {
        gameModel.score = 0
        currentScore.text = "\(gameModel.score)"
        for row in 0..<rows {
            for col in 0..<columns  {
                if gameModel.matrix[row][col].number != 0 {
                    gameModel.matrix[row][col].number = 0
                }
                gameMatrix[row][col].image.image = nil
            }
        }
        updateMatrix()
        gameModel.generateNewNumberForMatrix()
        gameModel.generateNewNumberForMatrix()
        updateMatrix()
        if let view = menuBar {
            view.removeFromSuperview()
        }
        if let view = lostBar {
            view.removeFromSuperview()
        }
        if let view = winBar {
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
//        scoresTracking()
        for row in 0..<rows {
            for col in 0..<columns  {
                if gameModel.matrix[row][col].number != 0 {
                    let block = gameMatrix[row][col]
                    if let image = UIImage(named: "\(gameModel.matrix[row][col].number)") {
                        block.image.image = image
                    }
                } else {
                    let block = gameMatrix[row][col]
                    block.image.image = nil
                }
            }
        }
    }
    
    func createWinBar() {
        let overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.view.addSubview(overlayView)
        let youWon = UILabel()
        youWon.text = "You Won!"
        
        youWon.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(youWon)
        
        youWon.font = youWon.font.withSize(33)
        let button = UIButton(type: .system)
        if let image = UIImage(named:"restart") {
            button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        overlayView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        ]   )
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        NSLayoutConstraint.activate([
            youWon.topAnchor.constraint(equalTo: button.topAnchor, constant: -40)
        ])
        youWon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.clipsToBounds = false
        winBar = overlayView
        
        button.addTarget(self, action: #selector(restarting), for: .touchUpInside)
        
    }
    
    func createLostBar() {
        let overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        self.view.addSubview(overlayView)
        // Create buttons
        let youLost = UILabel()
        youLost.text = "You Lost!"
        
        youLost.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(youLost)
        
        youLost.font = UIFont.systemFont(ofSize: 33, weight: .semibold)
        
        let button = UIButton(type: .system)
        if let image = UIImage(named:"restart") {
            button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        overlayView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        ]   )
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        NSLayoutConstraint.activate([
            youLost.topAnchor.constraint(equalTo: button.topAnchor, constant: -40)
        ])
        youLost.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.clipsToBounds = false
        lostBar = overlayView
        
        button.addTarget(self, action: #selector(restarting), for: .touchUpInside)
        
    }
}
