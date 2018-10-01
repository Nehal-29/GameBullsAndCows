//
//  AvailableUsersViewController.swift
//  Hackhathon
//
//  Created by QuestionPro on 28/09/18.
//  Copyright © 2018 Nehal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class AvailableUsersViewController: UIViewController {
    //MARK: Variable Declared
    @IBOutlet var availableTableView: UITableView!
    var userList: [UsersOnlineData] = []
    let cellID = "cellID"
    var gameLevel = ""
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        availableTableView.register(UINib(nibName: "AvailableCell", bundle: nil), forCellReuseIdentifier: cellID)
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Players Online"
    }

    func getDataForTheUsers() {
        let refArt = Database.database().reference().child("Users")
        refArt.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                self.userList = []
                //iterating through all the values
               self.createDataModelForTheAvailableSnapShot(snapshot: snapshot)
            }
            DispatchQueue.main.async {
                self.availableTableView.reloadData()
            }
        })
    }
    
    func addTheObserverForEverySingleEvent() {
        self.userList = []
        if let uid = Auth.auth().currentUser?.uid {
            _ = Database.database().reference().child("Users").child(uid).observe(DataEventType.value, with: { (snapshot) in
                self.userList = []
                if snapshot.childrenCount > 0 {
                  self.createDataModelForTheAvailableSnapShot(snapshot: snapshot)
                }
                self.availableTableView.reloadData()
            }, withCancel:nil)
        }
    }
    
    func createDataModelForTheAvailableSnapShot(snapshot: DataSnapshot) {
        if let objects = snapshot.children.allObjects as? [DataSnapshot] {
            for artists in objects {
                guard let artistObject = artists.value as? [String: AnyObject] else { return}
                let artistName  = artistObject["Email"] as? String ?? ""
                let artistId  = artistObject["id"] as? String ?? ""
                let artistGenre = artistObject["isOnline"] as? Bool
                let isPlaying = artistObject["isPlaying"] as? Bool
                let artist = UsersOnlineData(id: artistId, email: artistName, isOnline: artistGenre, isPlaying: isPlaying)
                if let email = UserDefaults.standard.value(forKey: "email") as? String {
                    if email != artistName {
                        self.userList.append(artist)
                    }
                }
            }
      }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getDataForTheUsers()
        self.addTheObserverForEverySingleEvent()
         self.availableTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension AvailableUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? AvailableCell else {
            fatalError()
        }
        let userInfo = self.userList[indexPath.row]
        cell.emailId.text = userInfo.email
        cell.isonlineLbl.layer.masksToBounds = true
        cell.isonlineLbl.layer.cornerRadius = cell.isonlineLbl.frame.width/2
        cell.letsPlay.tag = indexPath.row
        
        if let online = userInfo.isOnline, online {
          cell.letsPlay.alpha = 1.0
          cell.letsPlay.isEnabled = true
          cell.isonlineLbl.backgroundColor = UIColor.green
        } else {
           cell.letsPlay.alpha = 0.8
           cell.letsPlay.isEnabled = false
           cell.isonlineLbl.backgroundColor = UIColor.red
        }
        if let isPlaying = userInfo.isPlaying, isPlaying {
            cell.letsPlay.alpha = 0.8
            cell.letsPlay.isEnabled = false
            cell.letsPlay.setTitle("Playing", for: .normal)
        } else {
            cell.letsPlay.alpha = 1.0
            cell.letsPlay.isEnabled = true
            cell.letsPlay.setTitle("Play", for: .normal)
            cell.letsPlay.addTarget(self, action: #selector(self.pressPlayButton(button:)), for: .touchUpInside)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func pressPlayButton(button: UIButton) {
        if let email = UserDefaults.standard.value(forKey: "email") as? String,
           let autoIDKey = UserDefaults.standard.value(forKey: "AutoID") as? String {
        let userinfo = self.userList[button.tag]
        let id = userinfo.id ?? ""
        UserDefaults.standard.set(id, forKey: "playingWithWhom")
        UserDefaults.standard.synchronize()
        let playData = ["id": "" ,
                        "isPlaying": true,
                        "playingWithWhom": autoIDKey,
                        "playingName": email
            ] as [String : Any]
        
            _ = Database.database().reference().child("WantToPlay").child(id).updateChildValues(playData)
            
        }
        
        self.performSegue(withIdentifier: "AvailableToGameBoard", sender: self)
    }
}

