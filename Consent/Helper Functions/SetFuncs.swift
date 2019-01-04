//
//  SetFuncs.swift
//  Consent
//
//  Created by Grumpy1211 on 12/28/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SetFuncs{

    public static var uidCharacterLength = 10
    
    public static func setButton(btn: UIButtonX, color: CGColor!){
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        btn.layer.backgroundColor = color
        btn.isSelected = false
    }
    public static func setButtonImg(btn: UIButtonX, image: UIImage){
        btn.setImage(image, for: .normal)
    }

    public static func setTextFields(field: UITextFieldX, img: UIImage?){
        //field.layer.borderWidth = 1
        field.layer.borderColor = #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
        field.layer.cornerRadius = 15
        field.clipsToBounds = true
        field.delegate = self as? UITextFieldDelegate
        if(img != nil){
            field.leftPadding = 5
            field.leftImage = img
        }
    }

    public static func setLblSettings(lbl: UILabelX){
        let fontSize = lbl.font.pointSize
        lbl.font = UIFont(name: "Montserrat Medium", size: fontSize)
        lbl.adjustsFontSizeToFitWidth = true
        lbl.numberOfLines = 0
        lbl.lineBreakMode = NSLineBreakMode.byTruncatingTail
        lbl.minimumScaleFactor = 0.5
    }
    
    public static func setTxt(lbl: UILabelX){//, type: AlertType){
    
    }
    
    public static func setTextView(view: UITextView){
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        view.layer.borderColor = #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
        view.layer.borderWidth = 2
        let fontSize = view.font!.pointSize
        view.font = UIFont(name: "Montserrat Medium", size: fontSize)
        view.adjustsFontForContentSizeCategory = true
    }
    
    public static func getDate() -> String{
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        
        // get the date time String from the date object
        return formatter.string(from: currentDateTime) // 10/8/16 at 10:48 PM
    }
    public static func getFirebaseDate() -> String{
        // get the current date and time
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        
        // get the date time String from the date object
        return formatter.string(from: currentDateTime) // Oct 8, 2016 at 10:48 PM
    }
}
