//
//  SignUpVC.swift
//  Consent
//
//  Created by Grumpy1211 on 10/8/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import RSKImageCropper

class SignUpVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nextB: UIButtonX!
    @IBOutlet weak var backB: UIButtonX!
    
    @IBOutlet weak var pg1View: UIViewX!
    @IBOutlet weak var pg2View: UIViewX!
    @IBOutlet weak var pg3View: UIViewX!
    @IBOutlet weak var pg4View: UIViewX!
    @IBOutlet weak var pg5View: UIViewX!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarLbl: UILabelX!
    
    var currentPg = 1.0
    var numOfPgs = 5
    var timer: Timer!
    
    weak var pg1: Pg1View!
    weak var pg2: Pg2View!
    weak var pg3: Pg3View!
    weak var pg4: Pg4View!
    weak var pg5: Pg5View!
    
    var email = " "
    var pw = " "
    
    //Pg4 Variables (Camera)
    var imagePicker: UIImagePickerController!
    var defaultImageName = "id-card.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        pg1 = pg1View as? Pg1View
        pg2 = pg2View as? Pg2View
        pg3 = pg3View as? Pg3View
        pg4 = pg4View as? Pg4View
        pg5 = pg5View as? Pg5View
        
        progressBar.setProgress(0, animated: true)
        
        self.view.layer.borderColor = #colorLiteral(red: 0.7607843137, green: 0.7647058824, blue: 0.7725490196, alpha: 1)
        self.view.layer.borderWidth = 2
        
        SetFuncs.setTextFields(field: pg1.email, img: #imageLiteral(resourceName: "EmailIcon"))
        SetFuncs.setTextFields(field: pg1.pw, img: #imageLiteral(resourceName: "PasswordIcon"))
        SetFuncs.setTextFields(field: pg1.pwConfirm, img: #imageLiteral(resourceName: "PasswordIcon"))
        
        SetFuncs.setTextFields(field: pg2.firstName, img: #imageLiteral(resourceName: "NameIcon"))
        SetFuncs.setTextFields(field: pg2.middleName, img: #imageLiteral(resourceName: "NameIcon"))
        SetFuncs.setTextFields(field: pg2.lastName, img: #imageLiteral(resourceName: "NameIcon"))
        SetFuncs.setTextFields(field: pg2.phoneNum, img: #imageLiteral(resourceName: "PhoneNumIcon"))
        
        SetFuncs.setTextFields(field: pg3.otherText, img: nil)
        SetFuncs.setButtonImg(btn: pg3.maleB, image: #imageLiteral(resourceName: "UnselectedIcon"))
        SetFuncs.setButtonImg(btn: pg3.femaleB, image: #imageLiteral(resourceName: "UnselectedIcon"))
        SetFuncs.setButtonImg(btn: pg3.otherB, image: #imageLiteral(resourceName: "UnselectedIcon"))
        
        SetFuncs.setButton(btn: pg4.openCamB, color: #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1))
        SetFuncs.setButton(btn: pg4.openLibB, color: #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1))
        pg4.setPicImageView()
        
        SetFuncs.setButton(btn: pg5.resendB, color: #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1))
        
        setupPgViews(view: pg1View)
        setupPgViews(view: pg2View)
        setupPgViews(view: pg3View)
        setupPgViews(view: pg5View)
        
        backB.isHidden = false
        setPage(currPg: Float(currentPg))
        
        SetFuncs.setButton(btn: nextB, color: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nextB.awakeFromNib()
        setPg1Animation()
        //setPg2Animation()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //pg1Animation()
        
    }
    func setPg1Animation(){
        pg1.centerEmailConstraint.constant -= (view.bounds.width + 15)
        pg1.centerPWConstraint.constant -= (view.bounds.width + 15)
        pg1.centerPWConfirmConstraint.constant -= (view.bounds.width + 15)
    }
    func setPg2Animation(){
        pg2.centerFirstConstraint.constant -= (pg2.bounds.width + 15)
        pg2.centerMidConstraint.constant -= (pg2.bounds.width + 15)
        pg2.centerLastConstraint.constant -= (pg2.bounds.width + 15)
        pg2.centerPhoneNumConstraint.constant -= (pg2.bounds.width + 15)
    }
    func pg1Animation(){
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
            self.pg1.centerEmailConstraint.constant += (self.view.bounds.width + 15)
            self.pg1.layoutIfNeeded()
        }) { (true) in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
                self.pg1.centerPWConstraint.constant += (self.view.bounds.width + 15)
                self.pg1.layoutIfNeeded()
            }) { (true) in
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
                    self.pg1.centerPWConfirmConstraint.constant += (self.view.bounds.width + 15)
                    self.pg1.layoutIfNeeded()
                })
            }
        }
    }
    func pg2Animation(){
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            self.pg2.centerFirstConstraint.constant += (self.pg2.bounds.width + 15)
            self.pg2.layoutIfNeeded()
        }) { (true) in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
                self.pg2.centerMidConstraint.constant += (self.pg2.bounds.width + 15)
                self.pg2.layoutIfNeeded()
            }) { (true) in
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
                    self.pg2.centerLastConstraint.constant += (self.pg2.bounds.width + 15)
                    self.pg2.layoutIfNeeded()
                }) { (true) in
                    UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
                        self.pg2.centerPhoneNumConstraint.constant += (self.pg2.bounds.width + 15)
                        self.pg2.layoutIfNeeded()
                    })
                }
            }
        }
    }
    @objc func enableNextBtn(){
        if(shouldEnableNext()){
            nextB.layer.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
        }else{
            nextB.layer.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
        nextB.isEnabled = shouldEnableNext()
    }
    func setupPgViews(view:UIViewX!){
        view.layer.cornerRadius = 20
    }
    func setPage(currPg: Float){
        if(currPg == 5.0){
            pg5View.isHidden = false
            pg4View.isHidden = true
            pg3View.isHidden = true
            pg2View.isHidden = true
            pg1View.isHidden = true
            backB.isHidden = true
            createAccount()
            
            timer.invalidate()
        }else if(currPg == 4.0){
            pg5View.isHidden = true
            pg4View.isHidden = false
            pg3View.isHidden = true
            pg2View.isHidden = true
            pg1View.isHidden = true
            
        }else if(currPg == 3.0){
            pg5View.isHidden = true
            pg4View.isHidden = true
            pg3View.isHidden = false
            pg2View.isHidden = true
            pg1View.isHidden = true
        }else if(currPg == 2.0){
            pg5View.isHidden = true
            pg4View.isHidden = true
            pg3View.isHidden = true
            pg2View.isHidden = false
            pg1View.isHidden = true
            
            setPg1Animation()
            pg2Animation()
            
            email = pg1.email.text!
            pw = pg1.pw.text!
        }else if(currPg == 1.0){
            pg5View.isHidden = true
            pg4View.isHidden = true
            pg3View.isHidden = true
            pg2View.isHidden = true
            pg1View.isHidden = false
            
            setPg2Animation()
            pg1Animation()
            
            pg1.email.text = ""
            pg1.pw.text = ""
            pg1.pwConfirm.text = ""
            
            pg1.checkL.image = #imageLiteral(resourceName: "ErrorIcon")
            pg1.checkU.image = #imageLiteral(resourceName: "ErrorIcon")
            pg1.checkM.image = #imageLiteral(resourceName: "ErrorIcon")
            
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SignUpVC.enableNextBtn), userInfo: nil, repeats: true)
        }else{
            timer.invalidate()
            
            let sb = UIStoryboard(name: "SignUp", bundle:nil)
            
            let nextVC = sb.instantiateViewController(withIdentifier: "LoginVC")
            self.present(nextVC, animated:true, completion:nil)
        }
        
        progressBar.progress = currPg/Float(numOfPgs)
        progressBar.setProgress(progressBar.progress, animated: true)
        progressBarLbl.text = String(Int(currPg)) + " / \(numOfPgs)"
    }
    
    func checkPW(PW: String, PWC: String) -> Bool{
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let capTest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = capTest.evaluate(with: PW)
        
        if(PW.count > 8){
            pg1.checkL.image = #imageLiteral(resourceName: "SuccessIcon")
        }
        if(capitalresult){
            pg1.checkU.image = #imageLiteral(resourceName: "SuccessIcon")
        }
        if(PW.elementsEqual(PWC) && !(PW.isEmpty)){
            pg1.checkM.image = #imageLiteral(resourceName: "SuccessIcon")
        }else{
            pg1.checkM.image = #imageLiteral(resourceName: "ErrorIcon")
        }
        
        if(PW.count <= 8){
            pg1.checkL.image = #imageLiteral(resourceName: "ErrorIcon")
            return false
        }else if(!capitalresult){
            pg1.checkU.image = #imageLiteral(resourceName: "ErrorIcon")
            return false
        }else if(PW.isEmpty){
            pg1.checkM.image = #imageLiteral(resourceName: "ErrorIcon")
            return false
        }else if(!PW.elementsEqual(PWC)){
            pg1.checkM.image = #imageLiteral(resourceName: "ErrorIcon")
            return false
        }else{
            return true
        }
    }
    func shouldEnableNext() -> Bool {
        if currentPg == 1.0 {
            if let emailField = pg1.email.text {
                if emailField.isEmpty || AccountValidation.isValidEmail(email: emailField) == false {
                    return false
                }
            } else {
                return false
            }
            return checkPW(PW: pg1.pw.text!, PWC: pg1.pwConfirm.text!)
        } else if currentPg == 2.0 {
            guard let first = pg2.firstName.text, !first.isEmpty, let last = pg2.lastName.text, !last.isEmpty, let phone = pg2.phoneNum.text, !phone.isEmpty, AccountValidation.validatePhoneNum(value: phone) == false, phone.count == 10, Int64(phone) != nil else {
                return false
            }
            return true
        } else if currentPg == 3.0 {
            if !pg3.isGenderSelected() {
                return false
            }
            return true
        } else if currentPg == 4.0 {
            //let img = UIImage(named: defaultImageName)
            if pg4.savedProfilePic == nil {
                return false
            }
            return true
        }else if currentPg == 5.0 {
            if Auth.auth().currentUser == nil {
                return false
            }
            return true
        }
        return false
    }
    func sendEmailVerification(){
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            if error == nil && self.currentPg == 4.0{
                let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
                
                let nextVC = sb.instantiateViewController(withIdentifier: "Success")
                Constants.SuccessType = .REmail
                self.present(nextVC, animated:true, completion:nil)
            }else if error == nil{
                //NOTHING
            }else{
                let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
                let nextVC = sb.instantiateViewController(withIdentifier: "Error")
                Constants.ErrorType = .REmailFail
                self.present(nextVC, animated: true, completion: nil)
            }
        }
    }
    func createAccount(){
        Auth.auth().createUser(withEmail: email, password: pw) { (user, error) in
    
            func uploadProfilePic(_ img: UIImage, completion: @escaping (_ url: String?) -> ()){
                guard let uid = Auth.auth().currentUser?.uid.trunc(length: SetFuncs.uidCharacterLength) else { return }
                let profilePicRef = Storage.storage().reference(forURL: "gs://consent-bc442.appspot.com/").child("profile_images").child("user/\(uid)")
                
                guard let imageData = img.jpegData(compressionQuality: 0.5)else { return }
                
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"
                
                profilePicRef.putData(imageData, metadata: metaData) { (metaData, error) in
                    if error == nil, metaData != nil{
                        profilePicRef.downloadURL(completion: { (url, error) in
                            completion(url?.absoluteString)
                        })
                    }else{
                        print(error?.localizedDescription as Any)
                        completion(nil)
                    }
                }
            }
            
            if error == nil {
                print("You have successfully signed up")
                
                uploadProfilePic(self.pg4.savedProfilePic, completion: { (url) in
                    self.pg4.profilePicUrl = url
                    
                    let u = UserModel.init(email: self.email, pw: self.pw, firstName: self.pg2.firstName.text!, midName: self.pg2.middleName.text!, lastName: self.pg2.lastName.text!, phoneNum: self.pg2.phoneNum.text!, gender: self.pg3.chosenGender(), profilePic: self.pg4!.profilePicUrl, user: Auth.auth().currentUser!)
                    u.setValues()
                    
                    self.updateDisplayName()
                    
                    /*let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
                    let nextVC = sb.instantiateViewController(withIdentifier: "Success")
                    Constants.SuccessType = .AccountMade
                    self.present(nextVC, animated: true, completion: nil)*/
                    self.sendEmailVerification()
                })
            } else {
                let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
                let nextVC = sb.instantiateViewController(withIdentifier: "Error")
                Constants.ErrorType = .AccountMadeFail
                self.present(nextVC, animated: true, completion: nil)
            }
        }
    }
    func updateDisplayName(){
        let user = Auth.auth().currentUser
        if let user = user {
            let changeRequest = user.createProfileChangeRequest()
            
            changeRequest.displayName = user.uid.trunc(length: SetFuncs.uidCharacterLength)
            changeRequest.photoURL = NSURL(string: self.pg4!.profilePicUrl)! as URL
            changeRequest.commitChanges { error in
                if error != nil {
                    // An error happened.
                } else {
                    // Profile updated.
                }
            }
        }
    }
    @IBAction func next(_ sender: Any){
        currentPg+=1.0
        setPage(currPg: Float(currentPg))
    }
    
    @IBAction func back(_ sender: Any){
        if(currentPg == 2.0){
            setPage(currPg: 1.0)
            currentPg-=1.0
        }else if(currentPg == 3.0){
            setPage(currPg: 2.0)
            currentPg-=1.0
        }else if(currentPg == 4.0){
            setPage(currPg: 3.0)
            currentPg-=1.0
        }else if(currentPg == 5.0){
            backB.isHidden = true
        }else{
            let sb = UIStoryboard(name: "SignUp", bundle:nil)
            timer?.invalidate()
            
            let nextVC = sb.instantiateViewController(withIdentifier: "LoginVC")
            self.present(nextVC, animated:true, completion:nil)
        }
    }
    //pg4 code
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
                imageCropVC.delegate = self
                imageCropVC.modalTransitionStyle = .crossDissolve
                self.present(imageCropVC, animated: true)
            })
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            picker.dismiss(animated: false, completion: { () -> Void in
                var imageCropVC : RSKImageCropViewController!
                imageCropVC = RSKImageCropViewController(image: selectedImage!, cropMode: RSKImageCropMode.circle)
                imageCropVC.delegate = self
                imageCropVC.modalTransitionStyle = .crossDissolve
                self.present(imageCropVC, animated: true)
            })
        }
    }
    //pg5 View IBAction
    @IBAction func resendConfirmation(_ sender: UIButtonX){
        pg5.resendB.isHidden = true
        self.sendEmailVerification()
    }
}

class Pg1View: UIViewX {
    //Pg 1
    @IBOutlet weak var email: UITextFieldX!
    @IBOutlet weak var pw: UITextFieldX!
    @IBOutlet weak var pwConfirm: UITextFieldX!
    
    @IBOutlet weak var lengthE: UILabelX!
    @IBOutlet weak var upperE: UILabelX!
    @IBOutlet weak var matchE: UILabelX!
    @IBOutlet weak var checkL: UIImageViewX!
    @IBOutlet weak var checkU: UIImageViewX!
    @IBOutlet weak var checkM: UIImageViewX!
    
    @IBOutlet weak var centerEmailConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerPWConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerPWConfirmConstraint: NSLayoutConstraint!
    
}

class Pg2View: UIViewX {
    @IBOutlet weak var firstName: UITextFieldX!
    @IBOutlet weak var middleName: UITextFieldX!
    @IBOutlet weak var lastName: UITextFieldX!
    @IBOutlet weak var phoneNum: UITextFieldX!
    
    @IBOutlet weak var centerFirstConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerMidConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerLastConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerPhoneNumConstraint: NSLayoutConstraint!

}

class Pg3View: UIViewX{
    @IBOutlet weak var maleB: UIButtonX!
    @IBOutlet weak var femaleB: UIButtonX!
    @IBOutlet weak var otherB: UIButtonX!
    @IBOutlet weak var otherText: UITextFieldX!
    @IBOutlet weak var maleLbl: UILabelX!
    @IBOutlet weak var femaleLbl: UILabelX!
    @IBOutlet weak var otherLbl: UILabelX!
    @IBOutlet weak var genderLbl: UILabelX!
    
    func chosenGender() -> String{
        var gender = ""
        if(otherB.isSelected == true){
            gender = otherText.text!
        }else if(maleB.isSelected == true){
            gender = "Male"
        }else if(femaleB.isSelected == true){
            gender = "Female"
        }
        return gender
    }
    
    func setGenderBtnPic(){
        if(otherB.isSelected == true){
            SetFuncs.setButtonImg(btn: maleB, image: #imageLiteral(resourceName: "UnselectedIcon"))
            SetFuncs.setButtonImg(btn: femaleB, image: #imageLiteral(resourceName: "UnselectedIcon"))
            SetFuncs.setButtonImg(btn: otherB, image: #imageLiteral(resourceName: "SelectedIcon"))
        }else if(maleB.isSelected == true){
            SetFuncs.setButtonImg(btn: maleB, image: #imageLiteral(resourceName: "SelectedIcon"))
            SetFuncs.setButtonImg(btn: femaleB, image: #imageLiteral(resourceName: "UnselectedIcon"))
            SetFuncs.setButtonImg(btn: otherB, image: #imageLiteral(resourceName: "UnselectedIcon"))
        }else if(femaleB.isSelected == true){
            SetFuncs.setButtonImg(btn: maleB, image: #imageLiteral(resourceName: "UnselectedIcon"))
            SetFuncs.setButtonImg(btn: femaleB, image: #imageLiteral(resourceName: "SelectedIcon"))
            SetFuncs.setButtonImg(btn: otherB, image: #imageLiteral(resourceName: "UnselectedIcon"))
        }else{
            SetFuncs.setButtonImg(btn: maleB, image: #imageLiteral(resourceName: "UnselectedIcon"))
            SetFuncs.setButtonImg(btn: femaleB, image: #imageLiteral(resourceName: "UnselectedIcon"))
            SetFuncs.setButtonImg(btn: otherB, image: #imageLiteral(resourceName: "UnselectedIcon"))
        }
    }
    func isGenderSelected() -> Bool{
        let male = maleB.isSelected
        let female = femaleB.isSelected
        let other = otherB.isSelected
        
        if male == true {
            return true
        }else if female == true{
            return true
        }else if other == true{
            guard let otherText = otherText.text, !otherText.isEmpty else{
                return false
            }
            return true
        }
        return false
    }
    func updateSelects(pressed: UIButtonX){
        if(pressed.isEqual(otherB)){
            otherB.isSelected = true
            maleB.isSelected = false
            femaleB.isSelected = false
        }else if(pressed.isEqual(maleB)){
            maleB.isSelected = true
            femaleB.isSelected = false
            otherB.isSelected = false
        }else if(pressed.isEqual(femaleB)){
            femaleB.isSelected = true
            maleB.isSelected = false
            otherB.isSelected = false
        }
    }
    
    @IBAction func setGender(_ sender: UIButtonX){
        sender.isSelected = !sender.isSelected
        updateSelects(pressed: sender)
        setGenderBtnPic()
    }
}
class Pg4View: UIViewX{
    @IBOutlet weak var profilePicPreview: UIImageViewX!
    @IBOutlet weak var titleLbl: UILabelX!
    @IBOutlet weak var openCamB: UIButtonX!
    @IBOutlet weak var openLibB: UIButtonX!
    
    var savedProfilePic: UIImage!
    var profilePicUrl: String!
    
    func setPicImageView(){
        profilePicPreview.setRounded()
        profilePicPreview.borderWidth = 1
        profilePicPreview.borderColor = #colorLiteral(red: 0.7607843137, green: 0.7647058824, blue: 0.7725490196, alpha: 1)
        profilePicPreview.contentMode = .scaleAspectFill
    }
    func savePhoto(img: UIImage!){
        savedProfilePic = img
    }
    /*func savePhoto(){
        let imageData = profilePicPreview.image?.jpegData(compressionQuality: 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        //UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
     
    }*/
    func createCameraOverlay(imagePicker: UIImagePickerController){
        //Create camera overlay
        let pickerFrame = CGRect(x:0, y: UIApplication.shared.statusBarFrame.size.height, width: imagePicker.view.bounds.width, height: imagePicker.view.bounds.height - imagePicker.navigationBar.bounds.size.height - imagePicker.toolbar.bounds.size.height)
        let squareFrame = CGRect(x: pickerFrame.width/2 - 200/2, y: pickerFrame.height/2 - 200/2, width: profilePicPreview.frame.width, height: profilePicPreview.frame.height)
        //let squareFrame = CGRect(x: pickerFrame.width/2 - 200/2, y: pickerFrame.height/2 - 200/2, width: 200, height: 200)
        UIGraphicsBeginImageContext(pickerFrame.size)
        
        let context = UIGraphicsGetCurrentContext()
        context!.saveGState()
        context!.addRect((context?.boundingBoxOfClipPath)!)
        context?.move(to: CGPoint(x: squareFrame.origin.x, y: squareFrame.origin.y))
        context?.addLine(to: CGPoint(x:squareFrame.origin.x + squareFrame.width,y:squareFrame.origin.y))
        context?.addLine(to: CGPoint(x: squareFrame.origin.x + squareFrame.width, y:squareFrame.origin.y + squareFrame.size.height))
        context?.addLine(to:CGPoint(x: squareFrame.origin.x, y: squareFrame.origin.y + squareFrame.size.height))
        context?.addLine(to: CGPoint(x: squareFrame.origin.x, y: squareFrame.origin.y))
        context?.clip(using: .evenOdd)
        context?.move(to: CGPoint(x: pickerFrame.origin.x, y: pickerFrame.origin.y))
        context!.setFillColor(red: 0, green: 0, blue: 0, alpha: 0.25)
        context!.fill(pickerFrame)
        context!.restoreGState()
        
        let overlayImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        let overlayView = UIImageView(frame: pickerFrame)
        overlayView.image = overlayImage
        imagePicker.cameraOverlayView = overlayView
    }
    
}
class Pg5View: UIViewX{
    @IBOutlet weak var resendB: UIButtonX!

}
