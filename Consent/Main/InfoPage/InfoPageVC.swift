//
//  InfoPageVC.swift
//  Consent
//
//  Created by Grumpy1211 on 1/1/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase

class InfoPageVC: UIViewController {

    @IBOutlet weak var modeToggle: UISwitch!
    @IBOutlet weak var logoPic: UIImageViewX!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        modeToggle.isOn = ColorScheme.isDark
        logoPic.setRounded()
        //modeToggle.addTarget(self, action: Selector("stateChanged:"), for: .valueChanged)
    }
    @IBAction func back(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "MainVC")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
    @IBAction func stateChanged(switchState: UISwitch) {
        if modeToggle.isOn {
            ColorScheme.isDark = true
            modeToggle.isOn = true
        } else {
            ColorScheme.isDark = false
            modeToggle.isOn = false
        }
    }

}
