//
//  Label.swift
//  Consent
//
//  Created by Grumpy1211 on 12/27/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Label: UILabel{
    
    func setLblSettings(lbl: UILabel){
        let fontSize = lbl.font.pointSize
        lbl.font = UIFont(name: "Montserrat Medium", size: fontSize)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        lbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
        lbl.minimumScaleFactor = 0.5
    }

    func setTxt(lbl: UILabel){//, type: AlertType){

    }
    
}
