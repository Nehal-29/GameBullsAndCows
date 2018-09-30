//
//  ChooseStringVC.swift
//  Hackhathon
//
//  Created by QuestionPro on 30/09/18.
//  Copyright © 2018 Nehal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChooseStringVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var chooseTableDataView: UITableView!
    @IBOutlet var gameLevellbl: UILabel!
    var gameLevel = "";
    var chooseTableData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gamelevelStr = UserDefaults.standard.value(forKey: "gameLevel") as? String {
            self.gameLevel = gamelevelStr
            setTableViewDataAccordingToTheGameLevel(gameLbl: gamelevelStr)
        }
        chooseTableDataView.backgroundColor = UIColor.clear
        chooseTableDataView.layer.backgroundColor = UIColor.clear.cgColor
        self.chooseTableDataView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Do any additional setup after loading the view.
    }

    func setTableViewDataAccordingToTheGameLevel(gameLbl: String) {
        switch gameLbl {
        case "easy":
           self.dataForEasy()
        case "medium":
           self.dataForMedium()
        case "hard":
           self.dataForHard()
        default:
            self.dataForEasy()
        }
    }
    
    func dataForEasy() {
       chooseTableData = ["andy","Anty","peny","pane", "raam","meet"]
    }
    func dataForMedium() {
        
    }
    func dataForHard() {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chooseTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundView?.backgroundColor = UIColor.clear
        cell.textLabel?.text = chooseTableData[indexPath.row]
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let string = chooseTableData[indexPath.row]
        let refGame = Database.database().reference().child("PlayDetails")
        if let autoId = UserDefaults.standard.value(forKey: "AutoID") as? String {
            let userData = ["id": autoId, "choosenWord": string]
            refGame.child(autoId).setValue(userData)
        }
        UserDefaults.standard.set(string, forKey: "choosedWord")
        UserDefaults.standard.synchronize()
        let gameboard = GameBoardViewController.init(nibName: "GameBoardViewController", bundle: nil)
        gameboard.isGuesser = "isChooser"
        self.navigationController?.pushViewController(gameboard, animated: true)
    }
    
}
