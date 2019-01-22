//
//  EditVC.swift
//  Consent
//
//  Created by Grumpy1211 on 1/21/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase

class EditVC: UIViewController, UITextFieldXDelegate {

    @IBOutlet weak var nameLbl: UILabelX!
    @IBOutlet weak var emailLbl: UILabelX!
    @IBOutlet weak var genderEdit: UITextFieldX!
    @IBOutlet weak var uidLbl: UILabelX!
    @IBOutlet weak var profilePic: UIImageViewX!
    
    @IBOutlet weak var editPicB: UIButtonX!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        nameLbl.text = ProfilePageVC.name
        emailLbl.text = ProfilePageVC.email
        genderEdit.text = ProfilePageVC.gender
        uidLbl.text = ProfilePageVC.currUid
        
        profilePic.image = ProfilePageVC.profilePicImg
        
    }
   

}
