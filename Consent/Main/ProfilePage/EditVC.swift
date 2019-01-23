//
//  EditVC.swift
//  Consent
//
//  Created by Grumpy1211 on 1/21/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import RSKImageCropper

class EditVC: UIViewController, UITextFieldXDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameLbl: UILabelX!
    @IBOutlet weak var emailLbl: UILabelX!
    @IBOutlet weak var genderEdit: UITextFieldX!
    @IBOutlet weak var uidLbl: UILabelX!
    @IBOutlet weak var profilePic: UIImageViewX!
    
    @IBOutlet weak var editPicB: UIButtonX!
    @IBOutlet weak var saveB: UIButtonX!
    
    var originalImg: UIImage!
    public static var savedImg: UIImage!
    let userRef = Database.database().reference().child("users").child(ProfilePageVC.currUid)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        SetFuncs.setLblSettings(lbl: emailLbl)
        SetFuncs.setTextFields(field: genderEdit, img: nil)
        SetFuncs.setLblSettings(lbl: uidLbl)
        SetFuncs.setLblSettings(lbl: nameLbl)
        profilePic.setRounded()
            
        nameLbl.text = ProfilePageVC.name
        emailLbl.text = ProfilePageVC.email
        genderEdit.placeholder = ProfilePageVC.gender
        uidLbl.text = ProfilePageVC.currUid
        
        originalImg = ProfilePageVC.profilePicImg
        
        if(EditVC.savedImg != nil){
            profilePic.image = EditVC.savedImg
        } else{
            profilePic.image = ProfilePageVC.profilePicImg
        }
    }
    public static func savePhoto(img: UIImage!){
        EditVC.savedImg = img
    }
    @IBAction func saveEdits(_ sender: UIButtonX){
        if (!(genderEdit.text?.isEmpty)! && genderEdit.text != " " && genderEdit.text != ProfilePageVC.gender){
            userRef.updateChildValues(["gender": genderEdit.text!])
        }
        if (EditVC.savedImg != originalImg) {
            uploadProfilePic(img: EditVC.savedImg)
            ProfilePageVC.profilePicImg = EditVC.savedImg
        }
        let sb = UIStoryboard(name: "ProfilePage", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "ProfilePage")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
        
    }
    func uploadProfilePic(img: UIImage){
        guard let uid = Auth.auth().currentUser?.uid.trunc(length: SetFuncs.uidCharacterLength) else { return }
        let profilePicRef = Storage.storage().reference(forURL: "gs://consent-bc442.appspot.com/").child("profile_images").child("user/\(uid)")
        guard let imageData = EditVC.savedImg.jpegData(compressionQuality: 0.5)else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        profilePicRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if error == nil, metaData != nil{
                profilePicRef.downloadURL(completion: { (url, error) in
                    self.userRef.updateChildValues(["ProfilePic": url?.absoluteString])
                    ProfilePageVC.profilePicUrl = url?.absoluteString
                })
            }else{
                print(error?.localizedDescription as Any)
            }
        }
    }
    @IBAction func editPic(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "ProfilePage", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "ChangePfP")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
    @IBAction func back(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "ProfilePage", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "ProfilePage")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }

}
