//
//  RoundButton.swift
//  HighWaters
//
//  Created by David E Bratton on 11/19/18.
//  Copyright © 2018 David Bratton. All rights reserved.
//

import UIKit

class RoundButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        layer.borderWidth = 5
        clipsToBounds = true
        //layer.borderWidth = 3.0
        layer.borderColor = #colorLiteral(red: 0.6212110519, green: 0.8334299922, blue: 0.3770503998, alpha: 1)
        //layer.cornerRadius = 25
    }

}
