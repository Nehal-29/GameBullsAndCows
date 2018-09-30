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
    
    func saveGameLevel(gameStr: String) {
        UserDefaults.standard.set(gameStr, forKey: "gameLevel")
         UserDefaults.standard.synchronize()
        
    }
    
    @IBAction func hardButton(_ sender: Any) {
        self.gameLevel = "hard"
        self.saveGameLevel(gameStr: self.gameLevel)
    }
    
    
    @IBAction func mediumButton(_ sender: Any) {
        self.gameLevel = "medium"
        self.saveGameLevel(gameStr: self.gameLevel)
        
    }
    
    @IBAction func easyButton(_ sender: Any) {
        self.gameLevel = "easy"
        self.saveGameLevel(gameStr: self.gameLevel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationController = segue.destination as? AvailableUsersViewController else { return }
        destinationController.gameLevel = self.gameLevel
        
    }
    
}
