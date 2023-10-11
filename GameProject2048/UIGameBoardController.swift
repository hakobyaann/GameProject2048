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
    var gameModel = GameModel()
    var shouldKeepGoing: Bool = false
    
    @IBAction func menu(_ sender: Any) {
        createMenuBar()
    }

    func keepGoing(){
        gameModel.retrieveSaved()
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
        
//        let appWasTerminated = Notification.Name("AppWasTerminated")
//        NotificationCenter.default.post(name: appWasTerminated, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleTermination), name: appWasTerminated, object: nil)
        
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(handleTermination),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
    }
    
    @objc func handleTermination(){
        print("guppy")
        gameModel.save()
    }
    
    //MARK: functions for swiping/addition
    @objc func swipeLeft(){
        gameModel.additionLeft()
        currentScore.text = "\(gameModel.score)"
        updateMatrix()
    }
    
    @objc func swipeRight(){
        gameModel.additionRight()
        currentScore.text = "\(gameModel.score)"
        updateMatrix()
    }
    
    @objc func swipeUp(){
        gameModel.additionTop()
        currentScore.text = "\(gameModel.score)"
        updateMatrix()
    }
    
    @objc func swipeDown(){
        gameModel.additionBottom()
        currentScore.text = "\(gameModel.score)"
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
        gameModel.save()
//        gameModel.retrieveSaved(){
//            updateSaved()
//        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //restartButton tap action
    @objc func restarting(_ sender: UIButton) {
        for row in 0..<rows {
            for col in 0..<columns  {
                if gameModel.matrix[row][col].number != 0 {
                    gameModel.matrix[row][col].number = 0
                }
                gameMatrix[row][col].image.image = nil            }
        }
        updateMatrix()
        gameModel.generateNewNumberForMatrix()
        gameModel.generateNewNumberForMatrix()
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
        if gameModel.checking() && gameModel.emptyCoordinates.isEmpty {
            
        }
    }
//    }
//    
//    func updateSaved(){
//        for row in 0..<rows {
//            for col in 0..<columns  {
//                if gameModel.retrievedMatrix[row][col].number != 0 {
//                    let block = gameMatrix[row][col]
//                    if let image = UIImage(named: "\(gameModel.retrievedMatrix[row][col].number)") {
//                        block.image.image = image
//                    }
//                } else {
//                    let block = gameMatrix[row][col]
//                    block.image.image = nil
//                }
//            }
//        }
//    }
    
}
