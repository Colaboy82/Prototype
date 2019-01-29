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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
        
    @IBOutlet weak var email: UITextFieldX!
    @IBOutlet weak var password: UITextFieldX!
    @IBOutlet weak var loginB: UIButtonX!
    @IBOutlet weak var signUpB: UIButtonX!
    
    @IBOutlet weak var loginView: UIViewX!
    
    @IBOutlet weak var centerEmailConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerPWConstraint: NSLayoutConstraint!
    
    let service = "Consent_Prototype"
    var keychain: KeychainWrapper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keychain = KeychainWrapper(serviceName: service)

        self.hideKeyboardWhenTappedAround()
        
        SetFuncs.setTextFields(field: email, img: #imageLiteral(resourceName: "EmailIcon"), view: self)
        SetFuncs.setTextFields(field: password, img: #imageLiteral(resourceName: "PasswordIcon"), view: self)
        
        SetFuncs.setButton(btn:loginB, color: #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1))
        
        authenticationWithTouchID()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        centerEmailConstraint.constant -= (loginView.bounds.width + 15)
        centerPWConstraint.constant -= (loginView.bounds.width + 15)
        
        loginB.awakeFromNib()
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            self.centerEmailConstraint.constant += (self.loginView.bounds.width + 15)
            self.loginView.layoutIfNeeded()
        }, completion: { (true) in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
                self.centerPWConstraint.constant += (self.loginView.bounds.width + 15)
                self.loginView.layoutIfNeeded()
            })
        })
    }
    @IBAction func signUp(_ sender: Any){
        let sb = UIStoryboard(name: "SignUp", bundle:nil)
        
        let nextVC = sb.instantiateViewController(withIdentifier: "SignUpVC")
        self.present(nextVC, animated:true, completion:nil)
        
    }
    func saveKeychain(){
        keychain.set(email.text!, forKey: "email")
        keychain.set(password.text!, forKey: "password")
    }
    @IBAction func login(_ sender: Any){
        Auth.auth().signIn(withEmail: email.text!, password: password.text!){(user, error) in
            let authUser = user?.user
            if error == nil && (authUser?.isEmailVerified)!{
                
                if(self.keychain.string(forKey: "email") == nil && self.keychain.string(forKey: "password") == nil){
                    let alert = UIAlertController(title: "Keychain Access", message: "Do you want to save this account information?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
                        self.saveKeychain()
                        let sb = UIStoryboard(name: "Main", bundle:nil)
                        
                        let nextVC = sb.instantiateViewController(withIdentifier: "MainVC")
                        self.present(nextVC, animated:true, completion:nil)
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {(action) in
                        let sb = UIStoryboard(name: "Main", bundle:nil)
                        
                        let nextVC = sb.instantiateViewController(withIdentifier: "MainVC")
                        self.present(nextVC, animated:true, completion:nil)
                    }))
                    
                    self.present(alert, animated: true)
                }else{
                    
                    let sb = UIStoryboard(name: "Main", bundle:nil)
                    
                    let nextVC = sb.instantiateViewController(withIdentifier: "MainVC")
                    self.present(nextVC, animated:true, completion:nil)
                }
            }else{
                let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
                
                print(error?.localizedDescription as Any)
                
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
