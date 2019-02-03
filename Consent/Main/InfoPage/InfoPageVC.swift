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
    @IBOutlet weak var lightLbl: UILabelX!
    @IBOutlet weak var darkLbl: UILabelX!

    @IBOutlet weak var contractBtn: UIButtonX!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //modeToggle.isOn = ColorScheme.isDark
        logoPic.setRounded()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        logoPic.awakeFromNib()
        contractBtn.awakeFromNib()
        /*lightLbl.alpha = 0
        darkLbl.alpha = 0
        modeToggle.alpha = 0*/
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        /*lightLbl.alpha = 1
        darkLbl.alpha = 1
        modeToggle.alpha = 1*/
    }
    @IBAction func openContractDraft(_ sender: UIButtonX){
        
    }
    @IBAction func back(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "MainVC")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
    /*@IBAction func stateChanged(switchState: UISwitch) {
        if modeToggle.isOn {
            ColorScheme.isDark = true
            modeToggle.isOn = true
        } else {
            ColorScheme.isDark = false
            modeToggle.isOn = false
        }
    }*/

}
