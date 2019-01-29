//
//  AddEntryVC.swift
//  Consent
//
//  Created by Grumpy1211 on 1/1/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

class AddEntryVC: UIViewController {

    @IBOutlet weak var descriptionLbl: UILabelX!
    @IBOutlet weak var agreedActionTextBox: UITextView!
    @IBOutlet weak var uidTextBox: UITextFieldX!
    
    @IBOutlet weak var vidImgView: UIImageViewX!
    @IBOutlet weak var recordB: UIButtonX!
    @IBOutlet weak var vidSavedLbl: UILabelX!
    @IBOutlet weak var vidSavedIcon: UIImageViewX!
    
    @IBOutlet weak var submitB: UIButtonX!
    
    @IBOutlet weak var centerActionsConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerUIDConstraint: NSLayoutConstraint!

    var vidTimer: Timer!
    var btnTimer: Timer!
    
    var vidController = UIImagePickerController()
    var savedVid: URL!
    
    var uidExists = false
    
    let userRef = Database.database().reference()
    
    static var entryContent: Array<Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        AddEntryVC.entryContent = []
        
        setEntryFields()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        submitB.awakeFromNib()
        recordB.awakeFromNib()
        vidImgView.awakeFromNib()
        vidSavedIcon.awakeFromNib()
        
        descriptionLbl.alpha = 0
        vidSavedLbl.alpha = 0
        
        centerActionsConstraint.constant -= (view.bounds.width)
        centerUIDConstraint.constant -= (view.bounds.width)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
            self.centerActionsConstraint.constant += (self.view.bounds.width)
            self.view.layoutIfNeeded()
        }, completion: { (true) in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveLinear, animations: {
                self.centerUIDConstraint.constant += (self.view.bounds.width)
                self.view.layoutIfNeeded()
            })
        })
        
        descriptionLbl.alpha = 1
        vidSavedLbl.alpha = 1
    }
    func setEntryFields(){
        SetFuncs.setButton(btn: submitB, color: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
        SetFuncs.setButton(btn: recordB, color: #colorLiteral(red: 0.3254901961, green: 0.6666666667, blue: 0.7843137255, alpha: 1))
        
        SetFuncs.setTextFields(field: uidTextBox, img: #imageLiteral(resourceName: "SearchIcon"), view: self)
        SetFuncs.setTextView(view: agreedActionTextBox)
        
        btnTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(AddEntryVC.enableSubmitBtn), userInfo: nil, repeats: true)
        vidTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(AddEntryVC.vidIconCheck), userInfo: nil, repeats: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 1. replacementString is NOT empty means we are entering text or pasting text: perform the logic
        // 2. replacementString is empty means we are deleting text: return true
        if string.count > 0 {
            let allowedCharacters = CharacterSet.alphanumerics
            
            let unwantedStr = string.trimmingCharacters(in: allowedCharacters)
            return unwantedStr.count == 0
        }
        return true
    }
    @objc func vidIconCheck(){
        if (savedVid != nil){
            vidSavedIcon.image = #imageLiteral(resourceName: "SuccessIcon")
        } else {
            vidSavedIcon.image = #imageLiteral(resourceName: "ErrorIcon")
        }
    }
    @objc func enableSubmitBtn(){
        if (submitB.isEnabled){
            submitB.backgroundColor = #colorLiteral(red: 0.3254901961, green: 0.6666666667, blue: 0.7843137255, alpha: 1)
        } else {
            submitB.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
        submitB.isEnabled = shouldEnableSubmit()
    }
    func allFieldsFilled() -> Bool{
        guard let actions = agreedActionTextBox.text, !actions.isEmpty, let uid = uidTextBox.text, uidExists(uid: uid), savedVid != nil else {
            return false
        }
        return true
    }
    func uidExists(uid: String) -> Bool{
        guard let uid = uidTextBox.text, uid.isEmpty else{
            userRef.child("users").child(uidTextBox.text!).observeSingleEvent(of: .value, with: {(snapshot) in
                self.uidExists = snapshot.exists()
            })
            return uidExists
        }
        return uidExists
    }
    func shouldEnableSubmit() -> Bool{
        if !allFieldsFilled(){
            return false
        }
        return true
    }
    @IBAction func submit(_ sender: UIButtonX){
        btnTimer.invalidate()
        vidTimer.invalidate()
        
        let userRef = Database.database().reference().child("users").child(uidTextBox.text!)
        userRef.observeSingleEvent(of: .value, with: {(snapshot) in
            AddEntryVC.entryContent = [Auth.auth().currentUser!,
                                       SetFuncs.getDate(),
                                       self.uidTextBox.text!,
                                       self.savedVid!.absoluteString,
                                       snapshot.childSnapshot(forPath: "email").value as! String,
                                       snapshot.childSnapshot(forPath: "firstName").value as! String,
                                       snapshot.childSnapshot(forPath: "middleName").value as! String,
                                       snapshot.childSnapshot(forPath: "lastName").value as! String,
                                       snapshot.childSnapshot(forPath: "phoneNum").value as! String,
                                       snapshot.childSnapshot(forPath: "gender").value as! String,
                                       snapshot.childSnapshot(forPath: "ProfilePic").value as! String,
                                       self.agreedActionTextBox.text!,
                                       self.savedVid]
        })
        let d = SetFuncs.getFirebaseDate()
        userRef.updateChildValues(["RequestFromID":Auth.auth().currentUser?.uid.trunc(length: 10) as Any,
                                   "RequestDate": d])
        Constants.dateUsed = d
        
        let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "ConfirmConsent")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
    @IBAction func record(_ sender: UIButtonX){
        takeVid()
    }
    @IBAction func back(_ sender: UIButtonX){
        btnTimer.invalidate()
        vidTimer.invalidate()
        
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "MainVC")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
}

extension AddEntryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //called when a video is taken or chosen
        if let selectedVideo:URL = (info[UIImagePickerController.InfoKey.mediaURL] as? URL) {
            // Save video url
            savedVid = selectedVideo
        }
        picker.dismiss(animated: true)
    }
    func uploadVid(vidURL: URL, otherUID: String){
        guard let uid = Auth.auth().currentUser?.uid.trunc(length: SetFuncs.uidCharacterLength) else { return }
        let vidRef = Storage.storage().reference(forURL: "gs://consent-bc442.appspot.com/").child("consent_vids").child("user/\(uid)").child("\(otherUID)").child(Constants.dateUsed)
        
        vidRef.putFile(from: vidURL, metadata: nil, completion: {(metadata, error) in
            if error == nil {
                print("Successful video upload")
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    func takeVid(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Present UIImagePickerController to take video
            vidController.sourceType = .camera
            vidController.mediaTypes = [kUTTypeMovie as String]
            vidController.delegate = self
            vidController.modalTransitionStyle = .crossDissolve
            
            self.present(vidController, animated: true, completion: nil)
        }else{
            let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
            
            let nextVC = sb.instantiateViewController(withIdentifier: "Error")
            Constants.ErrorType = .CamE
            self.present(nextVC, animated:true, completion:nil)
        }
    }
}
