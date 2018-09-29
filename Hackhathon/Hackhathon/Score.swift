//
//  Score.swift
//  Hackhathon
//
//  Created by Nehal on 29/09/18.
//  Copyright © 2018 Nehal. All rights reserved.
//

import UIKit

class Score: NSObject {
    var answer: String
    var bulls: Int
    var cows:Int
    
    init(answer: String, bulls: Int, cows: Int) {
        self.answer = answer
        self.bulls = bulls
        self.cows = cows
    }
    
}
