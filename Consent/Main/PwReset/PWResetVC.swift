//
//  PWResetVC.swift
//  Consent
//
//  Created by Grumpy1211 on 12/24/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

class PWResetVC: UIViewController {
    
    var timer: Timer!

    @IBOutlet weak var email: UITextFieldX!
    @IBOutlet weak var resetB: UIButtonX!
    
    @IBOutlet weak var centerPWConstraint: NSLayoutConstraint!
    
    let service = "Consent_Prototype"
    var keychain: KeychainWrapper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keychain = KeychainWrapper(serviceName: service)

        self.hideKeyboardWhenTappedAround()
        
        SetFuncs.setTextFields(field: email, img: #imageLiteral(resourceName: "EmailIcon"), view: self)
        SetFuncs.setButton(btn: resetB, color:#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self,
                    selector: #selector(PWResetVC.enableBtn), userInfo: nil, repeats: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetB.awakeFromNib()
        centerPWConstraint.constant -= (view.bounds.width)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            self.centerPWConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    @objc func enableBtn(){
        if(shouldEnableResetBtn()){
            resetB.layer.backgroundColor = #colorLiteral(red: 0.3254901961, green: 0.6666666667, blue: 0.7843137255, alpha: 1)
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
        Auth.auth().sendPasswordReset(withEmail: email.text!, completion:{ (error) in
            if(error != nil){
                let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
                
                let nextVC = sb.instantiateViewController(withIdentifier: "Error")
                Constants.ErrorType = .RPWFail
                self.present(nextVC, animated:true, completion:nil)
                print((error?.localizedDescription)!)
            }else{
                self.keychain.removeAllKeys()
                let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
                
                let nextVC = sb.instantiateViewController(withIdentifier: "Success")
                Constants.SuccessType = .RPW
                self.present(nextVC, animated:true, completion:nil)
                self.email.text = ""
            }
        })
    }
    
    @IBAction func back(_ sender: Any){
        timer.invalidate()
        if Auth.auth().currentUser != nil{//         If already logged in
            do{
                let sb = UIStoryboard(name: "ProfilePage", bundle:nil)
                let nextVC = sb.instantiateViewController(withIdentifier: "ProfilePage")
                nextVC.modalTransitionStyle = .crossDissolve
                self.present(nextVC, animated:true, completion:nil)
                
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        }else{//not logged in
            let sb = UIStoryboard(name: "SignUp", bundle:nil)
            
            let nextVC = sb.instantiateViewController(withIdentifier: "LoginVC")
            self.present(nextVC, animated:true, completion:nil)
        }
    }

}
