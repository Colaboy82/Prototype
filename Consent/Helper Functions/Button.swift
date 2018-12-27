//
//  Button.swift
//  Consent
//
//  Created by Grumpy1211 on 12/24/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Button: UIButton{
    
    func setButton(btn: UIButton!, color: CGColor!){
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        btn.layer.backgroundColor = color
    }
    
}
