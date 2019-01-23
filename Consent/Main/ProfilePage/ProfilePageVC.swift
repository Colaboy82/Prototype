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

    @IBOutlet weak var mainMenuB: UIButtonX!
    @IBOutlet weak var resetB: UIButtonX!
    @IBOutlet weak var editB: UIButtonX!
    @IBOutlet weak var signOutB: UIButtonX!
    
    @IBOutlet weak var nameLbl: UILabelX!
    @IBOutlet weak var emailLbl: UILabelX!
    @IBOutlet weak var genderLbl: UILabelX!
    @IBOutlet weak var uidLbl: UILabelX!
    @IBOutlet weak var profilePic: UIImageViewX!
    
    var resetBCenter: CGPoint!
    var editBCenter: CGPoint!
    var signOutBCenter: CGPoint!
    
    public static var profilePicUrl: String!
    public static var name: String!
    public static var email: String!
    public static var gender: String!
    public static var currUid: String!
    
    public static var profilePicImg: UIImage!
    
    let uid = Auth.auth().currentUser?.uid.trunc(length: SetFuncs.uidCharacterLength)
    let userRef = Database.database().reference().child("users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        SetFuncs.setLblSettings(lbl: emailLbl)
        SetFuncs.setLblSettings(lbl: genderLbl)
        SetFuncs.setLblSettings(lbl: uidLbl)
        SetFuncs.setLblSettings(lbl: nameLbl)
        profilePic.setRounded()
        
        self.mainMenuB.setRounded()
        self.mainMenuB.isSelected = false
        
        self.resetB.alpha = 0
        self.editB.alpha = 0
        self.signOutB.alpha = 0
        
        userRef.child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
            ProfilePageVC.email = Auth.auth().currentUser?.email
            ProfilePageVC.gender = snapshot.childSnapshot(forPath:"gender").value as? String
            let first = snapshot.childSnapshot(forPath:"firstName").value as? String
            let mid = snapshot.childSnapshot(forPath:"middleName").value as? String
            let last = snapshot.childSnapshot(forPath:"lastName").value as? String
            ProfilePageVC.name = first! + " " + mid! + " " + last!
            ProfilePageVC.profilePicUrl = snapshot.childSnapshot(forPath:"ProfilePic").value as? String
            ProfilePageVC.currUid = self.uid
            if(ProfilePageVC.profilePicUrl != nil){
               self.setValues()
            }
        })

    }
    override func viewDidLayoutSubviews() {
        resetBCenter = resetB.center
        editBCenter = editB.center
        signOutBCenter = signOutB.center
        
        resetB.center = mainMenuB.center
        editB.center = mainMenuB.center
        signOutB.center = mainMenuB.center
    }
    func setValues(){
        var pic: UIImage!
        
        if (pic == nil){
            profilePic.showAnimatedGradientSkeleton()
        }
        
        nameLbl.text = ProfilePageVC.name
        emailLbl.text = ProfilePageVC.email
        genderLbl.text = ProfilePageVC.gender
        uidLbl.text = ProfilePageVC.currUid
        
        let storageRef = Storage.storage().reference(forURL: ProfilePageVC.profilePicUrl)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            self.profilePic.hideSkeleton()
            pic = UIImage(data: data!)
            if(ProfilePageVC.profilePicImg == nil){
                self.profilePic.image = pic
                ProfilePageVC.profilePicImg = pic
            }else{
                self.profilePic.image = ProfilePageVC.profilePicImg
            }
        }
    }
    @IBAction func mainBClicked(_ sender: UIButtonX){
        //sender.toggleButtonImage(onImage: #imageLiteral(resourceName: "MainMenuB"), offImage: #imageLiteral(resourceName: "MainMenuB"))
        if sender.isSelected == false {
            //open buttons
            UIView.animate(withDuration: 0.3, animations: {
                self.resetB.alpha = 1
                self.editB.alpha = 1
                self.signOutB.alpha = 1
                
                self.resetB.center = self.resetBCenter
                self.editB.center = self.editBCenter
                self.signOutB.center = self.signOutBCenter
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.resetB.alpha = 0
                self.editB.alpha = 0
                self.signOutB.alpha = 0
                
                self.resetB.center = self.mainMenuB.center
                self.editB.center = self.mainMenuB.center
                self.signOutB.center = self.mainMenuB.center
            })
        }
        sender.isSelected = !sender.isSelected
    }
    @IBAction func resetBClicked(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "PWReset", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "PWResetVC")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
    @IBAction func editBClicked(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "ProfilePage", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "EditPage")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
    @IBAction func signOut(){
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
    @IBAction func back(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "MainVC")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }

}
