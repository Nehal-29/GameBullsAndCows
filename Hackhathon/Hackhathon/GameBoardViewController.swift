//
//  GameBoardViewController.swift
//  Hackhathon
//
//  Created by Nehal on 28/09/18.
//  Copyright © 2018 Nehal. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController {

    var resultantWord = ""
    var userInput = ""
    var cows = 0
    var bulls = 0
    let data = ["and","Ant","pen","pan", "raam","rard"]
    
    @IBOutlet private var userInputTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let randomIndex = Int(arc4random_uniform(UInt32(data.count)))
        self.resultantWord = data[randomIndex]
    }
    
    
    func bullsAndCowsLogic(inputString: String) {

        self.userInput = inputString
        if (userInput.count == resultantWord.count) && !inputString.isEmpty {
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
    }

}

extension GameBoardViewController: UITextFieldDelegate {
    
    //Remove it once textfield divided into different field
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text?.count == self.resultantWord.count {
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.bullsAndCowsLogic(inputString: textField.text ?? "")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Implement it to 1 char each textfield
        return true
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    } }
