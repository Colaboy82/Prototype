//
//  Error.swift
//  Consent
//
//  Created by Grumpy1211 on 12/27/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import UIKit
import Firebase

class SignOutPopUp: UIViewController {
    
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
        
        setMsgText()
    }
    func setMsgText(){
        msgText.text = "Are you sure you want to sign out?"
        
    }
    @IBAction func closePopUp(_ sender: Any){
        if Auth.auth().currentUser != nil{
            do{
                try Auth.auth().signOut()
                
                let sb = UIStoryboard(name: "SignUp", bundle:nil)
                let nextVC = sb.instantiateViewController(withIdentifier: "LoginVC")
                nextVC.modalTransitionStyle = .crossDissolve
                self.present(nextVC, animated:true, completion:nil)
                
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
