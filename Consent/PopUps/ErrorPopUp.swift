//
//  Error.swift
//  Consent
//
//  Created by Grumpy1211 on 12/27/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import UIKit
import Firebase

class ErrorPopUp: UIViewController {

    /**
     Type of Success Pop Up.
     
     - LoginFail: Reset Password
     - SubmitFail: submitted succesfully
     - REmailFail: resent Email
     - AccountMadeFail: error in creating account
     - RPWFail: error in resetting password
     - CamE: No Camera
     - PermE: Permission error
     - null: Not an alert type
     */
    enum ErrorType {
        case LoginFail, SubmitFail, REmailFail, AccountMadeFail, RPWFail, CamE, PermE, null
    }
    
    @IBOutlet weak var dismissPopUpB: UIButtonX!
    @IBOutlet weak var image: UIImageViewX!
    @IBOutlet weak var msgText: UILabelX!
    @IBOutlet weak var popUpView: UIViewX!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetFuncs.setButton(btn: dismissPopUpB, color: #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1))
        image.image = #imageLiteral(resourceName: "ErrorIcon")
        
        popUpView.layer.cornerRadius = 20
        popUpView.layer.masksToBounds = true
        
        SetFuncs.setLblSettings(lbl: msgText)
        
        setMsgText(type: Constants.ErrorType)
    }
    func setMsgText(type: ErrorType){
        if(type == .LoginFail){
            msgText.text = "Error with logging in. Please check all fields are correct"
        }else if(type == .SubmitFail){
            msgText.text = "Error with submission. Please check network connection or that you have filled in all required fields"
        }else if(type == .REmailFail){
            msgText.text = "Error when resending the confirmation email. Please Refresh and Try Again"
        }else if(type == .AccountMadeFail){
            msgText.text = "Error with Creating Account. Please Refresh and Try Again"
        }else if(type == .RPWFail){
            msgText.text = "Error with Resetting Password. Please Refresh and Try Again"
        }else if(type == .CamE){
            msgText.text = "Your camera seems to not be functional"
        }else if(type == .PermE){
            msgText.text = "It appears we do not have that permission. Please go into your settings and give us access"
        }else{
            msgText.text = "Error with App. Please Reset or Contact Employee"
        }
    }
    @IBAction func closePopUp(_ sender: Any){
        if (Constants.ErrorType == .SubmitFail){//person cancels on them
            let userRef = Database.database().reference().child("users")
            let uid = Auth.auth().currentUser?.uid.trunc(length: SetFuncs.uidCharacterLength)
            userRef.child(uid!).updateChildValues(["FailPopUp":false])
            dismiss(animated: true, completion: nil)
            
        } else{
            dismiss(animated: true, completion: nil)
        }
    }

}
