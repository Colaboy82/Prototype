//
//  ClickedEntryVC.swift
//  Consent
//
//  Created by Grumpy1211 on 1/17/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase

class ClickedEntryVC: UIViewController {

    @IBOutlet weak var profilePic: UIImageViewX!
    @IBOutlet weak var nameLbl: UILabelX!
    @IBOutlet weak var dateLbl: UILabelX!
    @IBOutlet weak var emailLbl: UILabelX!
    @IBOutlet weak var genderLbl: UILabelX!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.setRounded()
        SetFuncs.setLblSettings(lbl: nameLbl)
        SetFuncs.setLblSettings(lbl: emailLbl)
        SetFuncs.setLblSettings(lbl: genderLbl)
        SetFuncs.setLblSettings(lbl: dateLbl)



    }
    
    @IBAction func openContract(_ sender: UIButtonX){
        
    }
}
