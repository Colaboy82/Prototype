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
import LocalAuthentication

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
extension CamPFPVC: RSKImageCropViewControllerDelegate {
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        //EditVC.savedImg = croppedImage
        EditVC.savePhoto(img: croppedImage)
        self.dismiss(animated: true, completion: nil)
        
        let sb = UIStoryboard(name: "ProfilePage", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "EditPage")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        self.dismiss(animated: true, completion: nil)

        let sb = UIStoryboard(name: "ProfilePage", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "EditPage")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
}
extension UIViewController: UITextFieldXDelegate {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension SignInVC {
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    DispatchQueue.main.async {
                        self.email.text = self.keychain.string(forKey: "email")
                        self.password.text = self.keychain.string(forKey: "password")
                    }
                    
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
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

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}
