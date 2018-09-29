//
//  GameLevelViewController.swift
//  Hackhathon
//
//  Created by Nehal on 29/09/18.
//  Copyright © 2018 Nehal. All rights reserved.
//

import UIKit

class GameLevelViewController: UIViewController {

<<<<<<< Updated upstream
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

=======
    @IBAction func easyLevel(_ sender: Any) {
        self.performSegue(withIdentifier: "GameBoardViewController", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
>>>>>>> Stashed changes
}
