//
//  SuccessPopUp.swift
//  Consent
//
//  Created by Grumpy1211 on 12/26/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import UIKit
import Firebase

class SuccessPopUp: UIViewController {
    
    /**
     Type of Success Pop Up.
     
     - RPW: Reset Password
     - Submit: submitted succesfully
     - REmail: resent Email
     - null: Not an alert type
     */
    enum SuccessType {
        case RPW, Submit, REmail, null
    }
    
    @IBOutlet weak var dismissPopUpB: UIButtonX!
    @IBOutlet weak var image: UIImageViewX!
    @IBOutlet weak var msgText: UILabelX!
    @IBOutlet weak var popUpView: UIViewX!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetFuncs.setButton(btn: dismissPopUpB, color: #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1))
        
        popUpView.layer.cornerRadius = 20
        popUpView.layer.masksToBounds = true
        
        SetFuncs.setLblSettings(lbl: msgText)
        
        setMsgText(type: Constants.SuccessType)
    }
    func setMsgText(type: SuccessType){
        if(type == .RPW){
            msgText.text = "Email Sent Successfully. Check Email to Continue Resetting Password"
        }else if(type == .REmail){
            msgText.text = "Email Confirmation has been Resent"
        }else if(type == .Submit){
            msgText.text = "Submitted Successfully"
        }else{
            msgText.text = "Error with App. Please Reset or Contact Employee"
        }
    }
    @IBAction func closePopUp(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
}
