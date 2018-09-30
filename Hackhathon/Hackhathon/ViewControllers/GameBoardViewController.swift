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
    var data = [String]()
    var gameLevel = ""
    let maxAttempts = 10
    var attemptsTaken = 0
    var results = [Score]()
    let cellID = "cellID"
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var levelIndicator: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var userInputTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let gamelevelStr = UserDefaults.standard.value(forKey: "gameLevel") as? String {
             self.gameLevel = gamelevelStr
        }
        self.userInputTextField.delegate = self
        self.data = Data.dataDictionary(gameLevel: self.gameLevel)
        let randomIndex = Int(arc4random_uniform(UInt32(data.count)))
        self.resultantWord = data[randomIndex]
        self.tableView.layer.cornerRadius = 20
        self.tableView.clipsToBounds = true
        self.tableView.register(UINib.init(nibName: "AttemptedAnswerCellTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        self.navigationController?.navigationBar.isHidden = true
        self.checkButton.isEnabled = false
        self.checkButton.alpha = 0.5
        self.levelIndicator.text = "Maximum \(self.endGame()) characters allowed !!!"
        self.levelIndicator.font = UIFont.boldSystemFont(ofSize: 14)
        self.userInputTextField.keyboardType = .asciiCapable
        self.userInputTextField.autocorrectionType = .no
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
                let alert = UIAlertController(title: "Woah! Answer is \(self.resultantWord)", message: "Winner Winner Chicken Dinner", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                    if let controllers = self.navigationController?.viewControllers {
                        self.navigationController?.popToViewController(controllers[1], animated: true) }
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.tableView.reloadData()
            }
            
        } else {
            let alert = UIAlertController(title: "Game Over! Answer is \(self.resultantWord)", message: "Number of attempts exceeded !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                if let controllers = self.navigationController?.viewControllers {
                    self.navigationController?.popToViewController(controllers[1], animated: true) }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        self.resetData()
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
            self.checkButton.isEnabled = true
            self.checkButton.alpha = 1
            return true
        }
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: string)
        let isCharacter = CharacterSet.letters.isSuperset(of: allowedCharacters)
        if string == " " || string == "." {
            return false
        }
        
        if isCharacter {
            switch self.gameLevel {
            case "easy":
                if textField.text?.count == 4 {
                    if string == "" {
                        return true
                    }else {
                        self.checkButton.isEnabled = true
                        self.checkButton.alpha = 1
                        _ = textField.resignFirstResponder()
                        return false
                    }
                } else {
                    return true
                }
            case "medium":
                if textField.text?.count == 5 {
                    if string == "" {
                        return true
                    }else {
                        self.checkButton.isEnabled = true
                        self.checkButton.alpha = 1
                        _ = textField.resignFirstResponder()
                        return false
                    }
                } else {
                    return true
                }
            case "hard":
                if textField.text?.count == 6 {
                    if string == "" {
                        return true
                    }else {
                        self.checkButton.isEnabled = true
                        self.checkButton.alpha = 1
                        _ = textField.resignFirstResponder()
                        return false
                    }
                } else {
                    return true
                }
            default:
                return true
            }
        } else {
            return false
        }
    }
}

extension GameBoardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? AttemptedAnswerCellTableViewCell else { return AttemptedAnswerCellTableViewCell() }
        
        let score = self.results[indexPath.row]
        if let cellToUpdate = tableView.cellForRow(at: indexPath) as? AttemptedAnswerCellTableViewCell {
            cellToUpdate.configureCell(answer: score.answer, bulls: score.bulls, cows: score.cows)
        } else {
            cell.configureCell(answer: score.answer, bulls: score.bulls, cows: score.cows)
        }
        return cell
    }
}
