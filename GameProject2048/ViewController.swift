//
//  ViewController.swift
//  GameProject2048
//
//  Created by Anna Hakobyan on 18.09.23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func keepGoing(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "gameViewController") as! UIGameBoardController
        
        vc.shouldKeepGoing = true
        show(vc, sender: nil)

        
    }
    
    


}

