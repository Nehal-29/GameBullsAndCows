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
    var playView: UIView = UIView.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTxt.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        self.usernameTxt.keyboardType = .emailAddress
        self.usernameTxt.autocorrectionType = .no
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
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
                let key = refArt.childByAutoId().key ?? ""
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set(key, forKey: "AutoID")
                UserDefaults.standard.synchronize()
                let userData = ["id":key,
                                "Email": email,
                                "isOnline": true,
                                "isPlaying": false
                    ] as [String : Any]
                refArt.child(key).setValue(userData)
                let refWantToPlay = Database.database().reference().child("WantToPlay")
                let keyWantToPlay = refArt.childByAutoId().key
                UserDefaults.standard.set(keyWantToPlay ?? "", forKey: "WantToPlayKey")
                UserDefaults.standard.synchronize()
                let playData = ["id":keyWantToPlay ?? "",
                                "isPlaying": false,
                                "playingWithWhom": "",
                                 "playingName": ""
                    ] as [String : Any]
                refWantToPlay.child(key).setValue(playData)
                self.addTheObserverForPlayEvent()
            }
        }
    }
    
    func createPlayView() {
        let playViewCon = UIView.init()
        playViewCon.frame.size = CGSize(width: 300, height: 150)
        playViewCon.center = self.view.center
        playViewCon.tag = 1
        playViewCon.backgroundColor = UIColor.brown
        playView = playViewCon
        let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: playViewCon.frame.width, height: 40 ))
        if let playingName = UserDefaults.standard.value(forKey: "playingName") as? String {
            label.text = "Wants to play with " + playingName + " ?"
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            playView.addSubview(label)
            let playButton = UIButton.init(frame: CGRect(x: 5, y: 45, width: 60, height: 50))
            playButton.setTitle("Play", for: .normal)
            playButton.titleLabel?.textColor = UIColor.white
            playButton.addTarget(self, action: #selector(playButtonClicked(sender:)), for: .touchUpInside)
            playView.addSubview(playButton)
            let cancelButton = UIButton.init(frame: CGRect(x: self.playView.frame.width - 65, y: 45, width: 60, height: 50))
            cancelButton.titleLabel?.textColor = UIColor.white
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.addTarget(self, action: #selector(cancelButtonClicked(sender:)), for: .touchUpInside)
             playView.addSubview(cancelButton)
        }
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.playView)
        }
    }
    
    @objc func playButtonClicked(sender: UIButton) {
        DispatchQueue.main.async {
           self.playView.removeFromSuperview()
            self.performSegue(withIdentifier: "VCToGameBoard", sender: self)
        }
    }
    
    @objc func cancelButtonClicked(sender: UIButton) {
        DispatchQueue.main.async {
            self.playView.removeFromSuperview()
        }
        
    }
    
    func addTheObserverForPlayEvent() {
        
        if let autoIDKey = UserDefaults.standard.value(forKey: "AutoID") as? String {
            _ = Database.database().reference().child("WantToPlay").child(autoIDKey).observe(DataEventType.value, with: { (snapshot) in
                if snapshot.childrenCount > 0 {
                    print(snapshot)
                    if let snapValue = snapshot.value as? [String: Any] {
                        let playingWithWhom = snapValue["playingWithWhom"] as? String ?? ""
                        let playingName = snapValue["playingName"] as? String ?? ""
                        UserDefaults.standard.set(playingWithWhom, forKey: "playingWithWhom")
                        UserDefaults.standard.set(playingName, forKey: "playingName")
                        UserDefaults.standard.synchronize()
                        if playingWithWhom != "" {
                            DispatchQueue.main.async {
                                self.createPlayView()
                            }
                        }
                    }
                }
            }, withCancel: nil)
        }
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alert!", message: "Wrong Email ID", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //MARK: Submit Button Clicked
    @IBAction func submitButtonClicked() {
        
        if let text = self.usernameTxt.text, isValidEmail(testStr: text) {
            self.loginLogicForEmailAndPassword(email: text)
            self.performSegue(withIdentifier: "GameLevelViewController", sender: self)
        } else {
            showAlert()
        }
        
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
