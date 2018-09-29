//
//  AttemptedAnswerCellTableViewCell.swift
//  Hackhathon
//
//  Created by Nehal on 28/09/18.
//  Copyright © 2018 Nehal. All rights reserved.
//

import UIKit

class AttemptedAnswerCellTableViewCell: UITableViewCell {

    @IBOutlet weak var attemptedAnswerLabel: UILabel!
    @IBOutlet weak var cowsCount: UILabel!
    @IBOutlet weak var bullsCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(answer: String, bulls: Int, cows: Int) {
        self.attemptedAnswerLabel.text = answer
        self.bullsCount.text = "\(bulls)"
        self.cowsCount.text = "\(cows)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
