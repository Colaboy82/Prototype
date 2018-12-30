//
//  SignInVC.swift
//  Consent
//
//  Created by Grumpy1211 on 10/8/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//


//CREDIT AUTHOR FOR ICONS
import UIKit
import Firebase
import FirebaseAuth

class SignInVC: UIViewController, UITextFieldDelegate {
        
    @IBOutlet weak var email: UITextFieldX!
    @IBOutlet weak var password: UITextFieldX!
    @IBOutlet weak var loginB: UIButtonX!
    @IBOutlet weak var signUpB: UIButtonX!
    
    override func viewDidLoad() {
        SetFuncs.setTextFields(field: email, img: #imageLiteral(resourceName: "EmailIcon"))
        SetFuncs.setTextFields(field: password, img: #imageLiteral(resourceName: "PasswordIcon"))
        
        SetFuncs.setButton(btn:loginB, color: #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1))
        
        //signUpB.layer.cornerRadius = 15
        signUpB.clipsToBounds = true
        
        super.viewDidLoad()
        
    }
    
    @IBAction func signUp(_ sender: Any){
        let sb = UIStoryboard(name: "SignUp", bundle:nil)
        
        let nextVC = sb.instantiateViewController(withIdentifier: "SignUpVC")
        self.present(nextVC, animated:true, completion:nil)
        
    }
    
    @IBAction func login(_ sender: Any){
        Auth.auth().signIn(withEmail: email.text!, password: password.text!){(user, error) in
            let authUser = user?.user
            if error == nil && (authUser?.isEmailVerified)!{
                let sb = UIStoryboard(name: "Main", bundle:nil)
                
                let nextVC = sb.instantiateViewController(withIdentifier: "MainVC")
                self.present(nextVC, animated:true, completion:nil)
                
            }else{
                let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
                
                let nextVC = sb.instantiateViewController(withIdentifier: "Error")
                Constants.ErrorType = .LoginFail
                self.present(nextVC, animated:true, completion:nil)
            }
        }
    }
    @IBAction func forgotPW(_ sender: Any){
        let sb = UIStoryboard(name: "PWReset", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "PWResetVC")
        self.present(nextVC, animated:true, completion:nil)
    }
    @IBAction func privacyPolicy(_ sender: Any){
        
    }
    
    
}
