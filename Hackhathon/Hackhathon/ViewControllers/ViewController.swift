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

class UsersOnlineData: NSObject {
    var id: String?
    var email: String?
    var isOnline: Bool?
    var isPlaying: Bool?
    
    init(id: String?, email: String?, isOnline: Bool?, isPlaying: Bool?){
        self.id = id
        self.email = email
        self.isOnline = isOnline
        self.isPlaying = isPlaying
    }
}

class ViewController: UIViewController {

    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
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
              let refArt = Database.database().reference().child("Users")
                let key = refArt.childByAutoId().key
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(key ?? "", forKey: "AutoID")
                UserDefaults.standard.synchronize()
                let userData = ["id":key ?? "",
                              "Email": email,
                              "isOnline": true,
                              "isPlaying": false
                    ] as [String : Any]
                refArt.child(key!).setValue(userData)
                let refWantToPlay = Database.database().reference().child("WantToPlay")
                let keyWantToPlay = refArt.childByAutoId().key
                UserDefaults.standard.set(keyWantToPlay ?? "", forKey: "WantToPlayKey")
                UserDefaults.standard.synchronize()
                let playData = ["id":keyWantToPlay ?? "",
                                "isPlaying": false,
                                "playingWithWhom": ""
                    ] as [String : Any]
                refWantToPlay.child(key!).setValue(playData)
                self.addTheObserverForPlayEvent()
            }
        }
    }
    
    func addTheObserverForPlayEvent() {
        if let autoIDKey = UserDefaults.standard.value(forKey: "AutoID") as? String {
            print(autoIDKey)
            _ = Database.database().reference().child("WantToPlay").child(autoIDKey).observe(DataEventType.value, with: { (snapshot) in
                if snapshot.childrenCount > 0 {
                    print(snapshot)
                    
                    
                    
                }
            }, withCancel: nil)
            
        }
    }
    
    //MARK: Submit Button Clicked
    @IBAction func submitButtonClicked() {
        loginLogicForEmailAndPassword(email: usernameTxt.text!)
        self.performSegue(withIdentifier: "GameLevelViewController", sender: self)
    }
}

