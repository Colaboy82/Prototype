//
//  ClickedEntryVC.swift
//  Consent
//
//  Created by Grumpy1211 on 1/17/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import SkeletonView

class ClickedEntryVC: UIViewController {

    @IBOutlet weak var profilePic: UIImageViewX!
    @IBOutlet weak var nameLbl: UILabelX!
    @IBOutlet weak var dateLbl: UILabelX!
    @IBOutlet weak var emailLbl: UILabelX!
    @IBOutlet weak var genderLbl: UILabelX!

    public static var profilePicUrl: String!
    public static var name: String!
    public static var date: String!
    public static var email: String!
    public static var gender: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePic.setRounded()
        SetFuncs.setLblSettings(lbl: nameLbl)
        SetFuncs.setLblSettings(lbl: emailLbl)
        SetFuncs.setLblSettings(lbl: genderLbl)
        SetFuncs.setLblSettings(lbl: dateLbl)
        
        setValues()
        
    }
    
    func setValues(){
        var pic: UIImage!
        
        if (pic == nil){
            profilePic.showAnimatedGradientSkeleton()
        }
        
        nameLbl.text = ClickedEntryVC.name
        emailLbl.text = ClickedEntryVC.email
        genderLbl.text = ClickedEntryVC.gender
        dateLbl.text = ClickedEntryVC.date
        
        let storageRef = Storage.storage().reference(forURL: ClickedEntryVC.profilePicUrl)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            self.profilePic.hideSkeleton()
            pic = UIImage(data: data!)
            self.profilePic.image = pic
        }
    }
    
    @IBAction func openContract(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "ContractScreen")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
    
    @IBAction func back(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "MainVC")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
}
