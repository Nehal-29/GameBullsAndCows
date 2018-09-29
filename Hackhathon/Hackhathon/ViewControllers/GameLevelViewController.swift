//
//  GameLevelViewController.swift
//  Hackhathon
//
//  Created by Nehal on 29/09/18.
//  Copyright © 2018 Nehal. All rights reserved.
//

import UIKit

class GameLevelViewController: UIViewController {

    var gameLevel = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func hardButton(_ sender: Any) {
        self.gameLevel = "easy"

    }
    
    
    @IBAction func mediumButton(_ sender: Any) {
        self.gameLevel = "medium"
        
    }
    
    @IBAction func easyButton(_ sender: Any) {
        self.gameLevel = "hard"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationController = segue.destination as? AvailableUsersViewController else { return }
        destinationController.gameLevel = self.gameLevel
        
    }
    
}
