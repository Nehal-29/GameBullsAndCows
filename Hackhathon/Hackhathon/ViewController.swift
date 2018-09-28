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
    
    init(id: String?, email: String?, isOnline: Bool?){
        self.id = id
        self.email = email
        self.isOnline = isOnline
    }
}

class ViewController: UIViewController {

    @IBOutlet var usernameTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loginLogicForEmailAndPassword(email: "nehal56IOS@gmail.com")
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
                let userData = ["id":key ?? "",
                              "Email": email,
                              "isOnline": true
                    ] as [String : Any]
                refArt.child(key!).setValue(userData)
                print("Data Addded")
            }
        
        }
        let refArt = Database.database().reference().child("Users")
        refArt.observe(DataEventType.value, with: { (snapshot) in
             var artistList: [UsersOnlineData] = []
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                //iterating through all the values
                for artists in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let artistObject = artists.value as? [String: AnyObject]
                    let artistName  = artistObject?["Email"]
                    let artistId  = artistObject?["id"]
                    print(artistId!)
                    print(artistName!)
                    let artistGenre = artistObject?["isOnline"]
                    //creating artist object with model and fetched values
                    let artist = UsersOnlineData(id: artistId as! String?, email: artistName as! String?, isOnline: artistGenre as! Bool?)
                    //appending it to list
                    artistList.append(artist)
                }
            }
            print(artistList)
        })
    }
    //MARK: Submit Button Clicked
    @IBAction func submitButtonClicked() {
        loginLogicForEmailAndPassword(email: usernameTxt.text!)
    }
}

