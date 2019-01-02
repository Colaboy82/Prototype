//
//  ProfilePageVC.swift
//  Consent
//
//  Created by Grumpy1211 on 1/1/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase

class ProfilePageVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    @IBAction func back(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "MainVC")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
    @IBAction func signOut(){
        if Auth.auth().currentUser != nil{
            do{
                try Auth.auth().signOut()
                
                let sb = UIStoryboard(name: "SignUp", bundle:nil)
                let nextVC = sb.instantiateViewController(withIdentifier: "LoginVC")
                self.present(nextVC, animated:true, completion:nil)
                
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

}
