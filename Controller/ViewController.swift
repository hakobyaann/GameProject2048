//
//  ViewController.swift
//  GameProject2048
//
//  Created by Anna Hakobyan on 18.09.23.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var newGame: UIButton!
    @IBOutlet weak var howToPlay: UIButton!
    @IBOutlet weak var keepGoingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func keepGoing(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "gameViewController") as! UIGameBoardController
        
        if let _ = UserDefaults.standard.object(forKey: "savedBestScore"),
           let _ = UserDefaults.standard.object(forKey: "savedMatrix"),
           let _ = UserDefaults.standard.object(forKey: "MaxTile"),
           let _ = UserDefaults.standard.object(forKey: "CurrentScore") {
            // Code to handle the non-nil values
            vc.shouldKeepGoing = true
            show(vc, sender: nil)
            keepGoingButton.isEnabled = true
        } else {
            // Code to handle the case where any of the values is nil
            keepGoingButton.isEnabled = false
        }
        
    }
    
    @IBAction func newGame(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "gameViewController") as! UIGameBoardController
        vc.shouldStartNewGame = true
        show(vc, sender: nil)
    }
}
