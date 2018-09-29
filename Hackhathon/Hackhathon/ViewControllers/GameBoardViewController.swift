//
//  GameBoardViewController.swift
//  Hackhathon
//
//  Created by Nehal on 28/09/18.
//  Copyright © 2018 Nehal. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController, UIAlertViewDelegate {

    var resultantWord = ""
    var userInput = ""
    var cows = 0
    var bulls = 0
    let data = ["andy","Anty","peny","pane", "raam","meet"]
    var gameLevel = ""
    let maxAttempts = 10
    var attemptsTaken = 0
    var results = [Score]()
    
    @IBOutlet weak var levelIndicator: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var tableHeader: UIView!
    @IBOutlet private weak var userInputTextField: UITextField!
    
    @IBOutlet weak var headerContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randomIndex = Int(arc4random_uniform(UInt32(data.count)))
        self.resultantWord = data[randomIndex]
        self.tableView.layer.cornerRadius = 20
        self.tableView.clipsToBounds = true
        self.tableView.tableHeaderView = self.tableHeader
        self.navigationController?.navigationBar.isHidden = true
        self.checkButton.isEnabled = false
        self.checkButton.alpha = 0.5
        self.levelIndicator.text = "Maximum \(self.endGame()) characters allowed !!!"
        self.levelIndicator.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    private func addEntry(element: Score) {
        self.results.append(element)
    }
    
    private func resetData() {
        self.userInputTextField.text = ""
        self.bulls = 0
        self.cows = 0
        self.checkButton.isEnabled = false
        self.checkButton.alpha = 0.5
    }
    
    private func endGame() -> Int {
        switch self.gameLevel {
        case "easy":
            return 4
        case "medium":
            return 5
        case "hard":
            return 6
        default:
            return 0
        }
    }
    
    @IBAction func gameAction(_ sender: Any) {
        if self.attemptsTaken <= 10 {
        self.bullsAndCowsLogic(inputString: self.userInput)
            if self.bulls == self.endGame() {
                let alert = UIAlertController(title: "Woah!", message: "Winner Winner Chicken Dinner", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
            } else {
            self.tableView.reloadData()
            }
            
        } else {
            let alert = UIAlertController(title: "Game Over", message: "Number of attempts exceeded !", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    private func bullsAndCowsLogic(inputString: String) {

        self.userInput = self.userInputTextField.text ?? ""
         self.attemptsTaken = self.attemptsTaken + 1
        if (userInput.count == resultantWord.count) && !self.userInput.isEmpty {
            var arrayOfInputCharacters = [Character]()
            for i in 0..<self.userInput.count {
                let input = self.userInput.index(self.userInput.startIndex, offsetBy: i)
                let match = self.resultantWord.index(self.userInput.startIndex, offsetBy: i)
                if self.userInput[input] == self.resultantWord[match] {
                    self.bulls = self.bulls + 1
                }
            }
            for input in userInput {
                if self.resultantWord.contains(input) && !arrayOfInputCharacters.contains(input) {
                    self.cows = self.cows + 1
                }
                arrayOfInputCharacters.append(input)
            }
        }
        let score = Score(answer: self.userInput, bulls: self.bulls, cows: self.cows)
        self.addEntry(element: score)
        self.resetData()
    }

}

extension GameBoardViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.userInput = textField.text ?? ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text?.count == self.resultantWord.count {
            return true
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Implement it to 1 char each textfield
        switch self.gameLevel {
        case "easy":
            if textField.text?.count == 4 {
                self.checkButton.isEnabled = true
                self.checkButton.alpha = 1
                return false
            } else {
                return true
            }
        case "medium":
            if textField.text?.count == 5 {
                self.checkButton.isEnabled = true
                self.checkButton.alpha = 1
                return false
            } else {
                return true
            }
        case "hard":
            if textField.text?.count == 6 {
                self.checkButton.isEnabled = true
                self.checkButton.alpha = 1
                return false
            } else {
                return true
            }
        default:
            return true
        }
    }
}

extension GameBoardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "attemptedAnswerCell", for: indexPath) as? AttemptedAnswerCellTableViewCell else { return AttemptedAnswerCellTableViewCell() }
        
        let score = self.results[indexPath.row]
        if let cellToUpdate = tableView.cellForRow(at: indexPath) as? AttemptedAnswerCellTableViewCell {
            cellToUpdate.configureCell(answer: score.answer, bulls: score.bulls, cows: score.cows)
        } else {
            cell.configureCell(answer: score.answer, bulls: score.bulls, cows: score.cows)
        }
        return cell
    }
}
