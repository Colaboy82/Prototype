//
//  Button.swift
//  Consent
//
//  Created by Grumpy1211 on 12/24/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import RSKImageCropper

extension String {
    /*
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     - Parameter length: Desired maximum lengths of a string
     - Parameter trailing: A 'String' that will be appended after the truncation.
     
     - Returns: 'String' object.
     */
    func trunc(length: Int, trailing: String = "") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
}

extension UIImageViewX {
    
    func setRounded() {
        let radius = (self.frame.height) / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}

extension SignUpVC: RSKImageCropViewControllerDelegate {
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.pg4.profilePicPreview.image = croppedImage
        self.pg4.savePhoto(img: croppedImage)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension EditVC: RSKImageCropViewControllerDelegate {
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        self.profilePic.image = croppedImage
        self.savePhoto(img: croppedImage)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIButtonX {
    func setRounded() {
        let radius = (self.frame.height) / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    //must set image on button to current image
    func toggleButtonImage(onImage: UIImage, offImage: UIImage) {
        if self.currentImage == offImage {
            self.setImage(onImage, for: .normal)
        }else{
            self.setImage(offImage, for: .normal)
        }
    }
}
