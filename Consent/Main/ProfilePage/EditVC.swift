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
    
    var imagePicker: UIImagePickerController!
    var originalImg: UIImage!
    var savedImg: UIImage!
    let userRef = Database.database().reference().child("users").child(ProfilePageVC.currUid)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        if (self.restorationIdentifier == "EditPage"){
            SetFuncs.setLblSettings(lbl: emailLbl)
            SetFuncs.setTextFields(field: genderEdit, img: nil)
            SetFuncs.setLblSettings(lbl: uidLbl)
            SetFuncs.setLblSettings(lbl: nameLbl)
            profilePic.setRounded()
            
            nameLbl.text = ProfilePageVC.name
            emailLbl.text = ProfilePageVC.email
            genderEdit.placeholder = ProfilePageVC.gender
            uidLbl.text = ProfilePageVC.currUid
            
            profilePic.image = ProfilePageVC.profilePicImg
            originalImg = ProfilePageVC.profilePicImg
        }else{
            //SetFuncs.setButton(btn: <#T##UIButtonX#>, color: <#T##CGColor!#>)
        }
    }
    
    @IBAction func saveEdits(_ sender: UIButtonX){
        if (!(genderEdit.text?.isEmpty)! && genderEdit.text != " " && genderEdit.text != ProfilePageVC.gender){
            userRef.updateChildValues(["gender": genderEdit.text!])
        }
        if (savedImg != originalImg) {
            uploadProfilePic(img: savedImg)
        }
        
    }
    func uploadProfilePic(img: UIImage){
        guard let uid = Auth.auth().currentUser?.uid.trunc(length: SetFuncs.uidCharacterLength) else { return }
        let profilePicRef = Storage.storage().reference(forURL: "gs://consent-bc442.appspot.com/").child("profile_images").child("user/\(uid)")
        guard let imageData = savedImg.jpegData(compressionQuality: 0.5)else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        profilePicRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if error == nil, metaData != nil{
                profilePicRef.downloadURL(completion: { (url, error) in
                    self.userRef.updateChildValues(["ProfilePic": url?.absoluteString])
                })
            }else{
                print(error?.localizedDescription as Any)
            }
        }
    }
    func savePhoto(img: UIImage!){
        savedImg = img
    }
    @IBAction func editPic(_ sender: UIButtonX){
        
    }
    @IBAction func back(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "ProfilePage", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "ProfilePage")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func openCam(_ sender: UIButtonX) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate & RSKImageCropViewControllerDelegate
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            imagePicker.modalTransitionStyle = .crossDissolve
            //pg4.createCameraOverlay(imagePicker: imagePicker)
            imagePicker.cameraCaptureMode = .photo
            imagePicker.cameraDevice = .front
            self.present(imagePicker, animated: true)
        }else{
            let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
            
            let nextVC = sb.instantiateViewController(withIdentifier: "Error")
            Constants.ErrorType = .CamE
            self.present(nextVC, animated:true, completion:nil)
        }
    }
    @IBAction func openLib(_ sender: UIButtonX) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate & RSKImageCropViewControllerDelegate
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.modalTransitionStyle = .crossDissolve
            self.present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //called when a picture is taken or chosen
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            picker.dismiss(animated: false, completion: { () -> Void in
                var imageCropVC : RSKImageCropViewController!
                imageCropVC = RSKImageCropViewController(image: selectedImage!, cropMode: RSKImageCropMode.circle)
                imageCropVC.delegate = self as RSKImageCropViewControllerDelegate
                imageCropVC.modalTransitionStyle = .crossDissolve
                self.present(imageCropVC, animated: true)
            })
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            picker.dismiss(animated: false, completion: { () -> Void in
                var imageCropVC : RSKImageCropViewController!
                imageCropVC = RSKImageCropViewController(image: selectedImage!, cropMode: RSKImageCropMode.circle)
                imageCropVC.delegate = self as RSKImageCropViewControllerDelegate
                imageCropVC.modalTransitionStyle = .crossDissolve
                self.present(imageCropVC, animated: true)
            })
        }
    }
}
