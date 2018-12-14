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

class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginB: UIButton!
    @IBOutlet weak var signUpB: UIButton!
    
    override func viewDidLoad() {
        //email.layer.borderWidth = 1
        email.layer.borderColor = #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
        email.layer.cornerRadius = 15
        email.clipsToBounds = true
        
        //password.layer.borderWidth = 1
        password.layer.borderColor = #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
        password.layer.cornerRadius = 15
        password.clipsToBounds = true
        
        loginB.layer.cornerRadius = 15
        loginB.clipsToBounds = true
        
        //signUpB.layer.cornerRadius = 15
        signUpB.clipsToBounds = true
        
        super.viewDidLoad()
        
    }
    
    @IBAction func signUp(_ sender: Any){
        let sb = UIStoryboard(name: "SignUp", bundle:nil)
        
        let nextVC = sb.instantiateViewController(withIdentifier: "SignUpVC")
        self.present(nextVC, animated:true, completion:nil)
 
        //self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)//removes previous view controller

    }
    
    @IBAction func login(_ sender: Any){
        
    }
    @IBAction func forgotPW(_ sender: Any){
        
    }
    @IBAction func privacyPolicy(_ sender: Any){
        
    }

    
}
