//
//  AvailableCell.swift
//  Hackhathon
//
//  Created by QuestionPro on 28/09/18.
//  Copyright © 2018 Nehal. All rights reserved.
//

import UIKit

class AvailableCell: UITableViewCell {
    @IBOutlet var emailId: UILabel!
    @IBOutlet var isonlineLbl: UILabel!
    @IBOutlet var letsPlay: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
