//
//  TextField.swift
//  Consent
//
//  Created by Grumpy1211 on 12/24/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TextField: UITextField{
    
    func setTextFields(field: UITextField!){
        //field.layer.borderWidth = 1
        field.layer.borderColor = #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
        field.layer.cornerRadius = 15
        field.clipsToBounds = true
        field.delegate = self as? UITextFieldDelegate
    }
    
}
