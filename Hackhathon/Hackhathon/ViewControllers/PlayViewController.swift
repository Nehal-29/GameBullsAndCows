//
//  PlayViewController.swift
//  Hackhathon
//
//  Created by QuestionPro on 29/09/18.
//  Copyright © 2018 Nehal. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

    @IBOutlet var playWithlbl: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let playingName = UserDefaults.standard.value(forKey: "playingName") as? String {
            playWithlbl.lineBreakMode = .byWordWrapping
            playWithlbl.numberOfLines = 0
            playWithlbl.text = "Wants to play with " + playingName + " ? You are the Guesser "
            playButton.addTarget(self, action: #selector(playButtonClicked(sender:)), for: .touchUpInside)
            cancelButton.addTarget(self, action: #selector(cancelButtonClicked(sender:)), for: .touchUpInside)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func playButtonClicked(sender: UIButton) {
        DispatchQueue.main.async {
           UIApplication.shared.keyWindow!.viewWithTag(1)?.removeFromSuperview()
        }
       
        
    }
    
   @objc func cancelButtonClicked(sender: UIButton) {
        DispatchQueue.main.async {
           UIApplication.shared.keyWindow!.viewWithTag(1)?.removeFromSuperview()
        }
        
    }

}
