//
//  ViewController.swift
//  Hackhathon
//
//  Created by Nehal on 28/09/18.
//  Copyright © 2018 Nehal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginLogicForEmailAndPassword(email: "tanvigpfse3@gmail.com")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginLogicForEmailAndPassword(email: String) {
        Auth.auth().createUser(withEmail: email, password: "rt7qhqjgw") { (result, error) in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .invalidEmail:
                        print("Enter a valid email.")
                    case .emailAlreadyInUse:
                        print("Email already in use.")
                    default:
                        print("Error: \(error.localizedDescription)")
                    }
                }
        }
            if let _ = Auth.auth().currentUser {
               
            }
        
        }
    }
    //MARK: Submit Button Clicked
    @IBAction func submitButtonClicked() {
        loginLogicForEmailAndPassword(email: usernameTxt.text!)
    }
}

