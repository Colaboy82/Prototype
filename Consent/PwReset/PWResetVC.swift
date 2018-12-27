//
//  PWResetVC.swift
//  Consent
//
//  Created by Grumpy1211 on 12/24/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import UIKit

class PWResetVC: UIViewController, UITextFieldDelegate {
    
    var textField = TextField.init()
    var button = Button.init()
    var timer: Timer!

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var resetB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.setTextFields(field: email)
        button.setButton(btn: resetB, color:#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,
                    selector: #selector(PWResetVC.enableBtn), userInfo: nil, repeats: true)
    }
    @objc func enableBtn(){
        if(shouldEnableResetBtn()){
            resetB.layer.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
        }else{
            resetB.layer.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
        resetB.isEnabled = shouldEnableResetBtn()
    }
    func shouldEnableResetBtn() -> Bool{
        if let emailField = email.text {
            if emailField.isEmpty || AccountValidation.isValidEmail(email: emailField) == false {
                return false
            }
        } else {
            return false
        }
        return true
    }
    
    @IBAction func resetPW(_ sender: Any){
        timer.invalidate()
        let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
        
        let nextVC = sb.instantiateViewController(withIdentifier: "Success")
        successType.SuccessType = SuccessPopUp.SuccessType.RPW
        //SuccessPopUp.init().setSuccessType(type: SuccessPopUp.SuccessType.RPW)
        self.present(nextVC, animated:true, completion:nil)
    }
    
    @IBAction func back(_ sender: Any){
        //If not logged in
        let sb = UIStoryboard(name: "SignUp", bundle:nil)
        
        let nextVC = sb.instantiateViewController(withIdentifier: "LoginVC")
        self.present(nextVC, animated:true, completion:nil)
        
        /*
        *
         If already logged in
        *
        */
    }

}
