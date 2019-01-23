//
//  CamPFPVC.swift
//  Consent
//
//  Created by Grumpy1211 on 1/22/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import RSKImageCropper

class CamPFPVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var popUpView: UIViewX!
    @IBOutlet weak var importBtn: UIButtonX!
    @IBOutlet weak var camBtn: UIButtonX!
    @IBOutlet weak var cancelBtn: UIButtonX!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetFuncs.setButton(btn: importBtn, color: #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1))
        SetFuncs.setButton(btn: camBtn, color: #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1))
        SetFuncs.setButton(btn: cancelBtn, color: #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1))

        popUpView.layer.cornerRadius = 20
        popUpView.layer.masksToBounds = true
    }
    @IBAction func cancel(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "ProfilePage", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "EditPage")
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
