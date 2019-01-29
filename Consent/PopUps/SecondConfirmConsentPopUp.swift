//
//  SecondConfirmConsentPopUp.swift
//  Consent
//
//  Created by Grumpy1211 on 1/9/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import SkeletonView
import MobileCoreServices

class SecondConfirmConsentPopUp: UIViewController, YPSignatureDelegate {
    
    @IBOutlet weak var confirmBtn: UIButtonX!
    @IBOutlet weak var cancelBtn: UIButtonX!
    @IBOutlet weak var profilePic: UIImageViewX!
    
    @IBOutlet weak var nameLbl: UILabelX!
    @IBOutlet weak var genderLbl: UILabelX!
    @IBOutlet weak var agreeLbl: UILabelX!
    @IBOutlet weak var signatureView: YPDrawSignatureView!
    
    @IBOutlet weak var popUpView: UIViewX!
    
    @IBOutlet weak var vidImgView: UIImageViewX!
    @IBOutlet weak var recordB: UIButtonX!
    @IBOutlet weak var vidSavedLbl: UILabelX!
    @IBOutlet weak var vidSavedIcon: UIImageViewX!
    
    var vidTimer: Timer!
    var btnTimer: Timer!
    
    var vidController = UIImagePickerController()
    var savedVid: URL!
    
    var timer: Timer!
    var failPopUpTimer: Timer!
    
    var userID = Auth.auth().currentUser?.uid.trunc(length: 10)
    var userRef = Database.database().reference().child("users")
    var entryRef = Database.database().reference().child("ConsentEntries")
    
    var vidRef = Storage.storage().reference(forURL: "gs://consent-bc442.appspot.com/").child("consent_vids")
    var sigRef = Storage.storage().reference(forURL: "gs://consent-bc442.appspot.com/").child("consent_signatures")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(shouldEnable), userInfo: nil, repeats: true)
        vidTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SecondConfirmConsentPopUp.vidIconCheck), userInfo: nil, repeats: true)
        self.failPopUpTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
            timer in
            
            self.backgroundChecker(timer: timer)
        }
        
    }
    
    func setUp(){
        
        SetFuncs.setButton(btn: confirmBtn, color:#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
        confirmBtn.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        profilePic.setRounded()
        profilePic.borderWidth = 1
        profilePic.borderColor = #colorLiteral(red: 0.7607843137, green: 0.7647058824, blue: 0.7725490196, alpha: 1)
        profilePic.contentMode = .scaleAspectFill
        
        view.showAnimatedGradientSkeleton()
        
        signatureView.delegate = self
        signatureView.clear()
        signatureView.strokeColor = UIColor.black
        signatureView.strokeWidth = 1.0
        signatureView.layer.borderWidth = 1
        signatureView.layer.borderColor = #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
        signatureView.layer.cornerRadius = 10
        signatureView.clipsToBounds = true
        
        popUpView.layer.cornerRadius = 20
        popUpView.layer.masksToBounds = true
        
        loadInfo()
    }
    func loadInfo(){
        userRef.child(userID!).observe(.value, with: { (snapshot) in
            let userRequesting = snapshot.childSnapshot(forPath: "RequestFromID").value as! String
            //let date = snapshot.childSnapshot(forPath: "RequestDate").value as! String
            
            self.userRef.child(userRequesting).observe(.value, with: { (snapshot) in
                let profilePicUrl = snapshot.childSnapshot(forPath: "ProfilePic").value as! String
                
                let storageRef = Storage.storage().reference(forURL: profilePicUrl)
                // Download the data, assuming a max size of 1MB (you can change this as necessary)
                storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                    // Create a UIImage, add it to the array
                    
                    self.view.hideSkeleton()
                    let pic = UIImage(data: data!)
                    self.profilePic.image = pic
                }
                
                let first = snapshot.childSnapshot(forPath: "firstName").value as! String
                let mid = snapshot.childSnapshot(forPath: "middleName").value as! String
                let last = snapshot.childSnapshot(forPath: "lastName").value as! String
                
                self.nameLbl.text = "Name: \(first) \(mid) \(last)"
                let gender = snapshot.childSnapshot(forPath: "gender").value as! String
                self.genderLbl.text = "Gender: \(gender)"
            })
        })
    }
    @objc func vidIconCheck(){
        if (savedVid != nil){
            vidSavedIcon.image = #imageLiteral(resourceName: "SuccessIcon")
        } else {
            vidSavedIcon.image = #imageLiteral(resourceName: "ErrorIcon")
        }
    }
    @objc func shouldEnable(){
        if (signatureView.doesContainSignature && savedVid != nil){
            confirmBtn.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
            confirmBtn.isEnabled = true
        } else {
            confirmBtn.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            confirmBtn.isEnabled = false
        }
    }
    func checkFailPopUp(){
        guard let uid = Auth.auth().currentUser?.uid.trunc(length: SetFuncs.uidCharacterLength) else { return }
        userRef.child(uid).child("FailPopUp").observeSingleEvent(of: .value, with: {(snapshot) in
            guard let bool = snapshot.value as? Bool else { return }
            
            if bool == true {
                self.deleteEntryDueToCancellation()
                let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
                
                let nextVC = sb.instantiateViewController(withIdentifier: "Error")
                Constants.ErrorType = .SubmitFail
                self.failPopUpTimer.invalidate()
                self.timer.invalidate()
                self.present(nextVC, animated:true, completion:nil)
            }
        })
    }
    func backgroundChecker(timer:Timer) {
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            //print("do some background task")
            self.checkFailPopUp()
            DispatchQueue.main.async {
                //print("update some UI")
            }
        }
    }
    func uploadSignature(completion: @escaping (_ url: String?) -> ()){
        guard let uid = Auth.auth().currentUser?.uid.trunc(length: SetFuncs.uidCharacterLength) else { return }
        
        userRef.child(uid).observe(.value, with: { (snapshot) in
            let userRequesting = snapshot.childSnapshot(forPath: "RequestFromID").value as! String
            let date = snapshot.childSnapshot(forPath: "RequestDate").value as! String
            
            let sigRef = Storage.storage().reference(forURL: "gs://consent-bc442.appspot.com/").child("consent_signatures").child("user/\(userRequesting)").child("\(uid)").child(date + "Second")
        
            let metaData = StorageMetadata()
            metaData.contentType = "image/pdf"
        
            sigRef.putData(self.signatureView.getPDFSignature(), metadata: metaData) { (metaData, error) in
                if error == nil, metaData != nil{
                    sigRef.downloadURL(completion: { (url, error) in
                        completion(url?.absoluteString)
                    })
                }else{
                    print(error?.localizedDescription as Any)
                    completion(nil)
                }
            }
        })
    }
    func addEntryToDatabase(){
        userRef.child(userID!).observe(.value, with: { (snapshot) in
            let userRequesting = snapshot.childSnapshot(forPath: "RequestFromID").value as! String
            let date = snapshot.childSnapshot(forPath: "RequestDate").value as! String
            
            self.entryRef.child(userRequesting).child(self.userID!).child(date).observe(.value, with: {(snapshot) in
                let savedDate = snapshot.childSnapshot(forPath: "Date").value as! String
                let vidUrl = snapshot.childSnapshot(forPath: "VidUrl").value as! String
                let agreedActions = snapshot.childSnapshot(forPath: "AgreedActions").value as! String
                let firstSign = snapshot.childSnapshot(forPath: "FirstSignature").value as! String
                let secondSign = snapshot.childSnapshot(forPath: "secondSignature").value as! String
            
                self.userRef.child(userRequesting).observe(.value, with: {(snapshot) in
                    let entryArray = [Auth.auth().currentUser!,
                                      savedDate,
                                      userRequesting,
                                      vidUrl,
                                      snapshot.childSnapshot(forPath: "email").value as! String,
                                      snapshot.childSnapshot(forPath: "firstName").value as! String,
                                      snapshot.childSnapshot(forPath: "middleName").value as! String,
                                      snapshot.childSnapshot(forPath: "lastName").value as! String,
                                      snapshot.childSnapshot(forPath: "phoneNum").value as! String,
                                      snapshot.childSnapshot(forPath: "gender").value as! String,
                                      snapshot.childSnapshot(forPath: "ProfilePic").value as! String,
                                      agreedActions,
                                      firstSign,
                                      secondSign] as [Any]
                
                    let e = ConsentEntryModel.init(user: entryArray[0] as! User,
                                                   date: entryArray[1] as! String,
                                                   otherUserID: entryArray[2] as! String,
                                                   vidUrl: entryArray[3] as! String,
                                                   email: entryArray[4] as! String,
                                                   firstName: entryArray[5] as! String,
                                                   midName: entryArray[6] as! String,
                                                   lastName: entryArray[7] as! String,
                                                   phoneNum: entryArray[8] as! String,
                                                   gender: entryArray[9] as! String,
                                                   profilePicUrl: entryArray[10] as! String,
                                                   agreedActions: entryArray[11] as! String,
                                                   firstSignature: entryArray[12] as! String,
                                                   secondSignature: entryArray[13] as! String)
                    e.createDuplicateEntry(savedDate: date)
                    
                    let newRef = self.entryRef.child(self.userID!).child(entryArray[2] as! String).child(date)
                    newRef.updateChildValues(["Confirmed": true])
                })
            })
        })
    }
    func deleteEntryDueToCancellation(){
        userRef.child(userID!).observe(.value, with: { (snapshot) in
            let userRequesting = snapshot.childSnapshot(forPath: "RequestFromID").value as! String
            let date = snapshot.childSnapshot(forPath: "RequestDate").value as! String
            
            self.entryRef.child(userRequesting).removeValue()
            let v = self.vidRef.child("user/\(userRequesting)").child(self.userID!).child(date)
            let s = self.sigRef.child("user/\(userRequesting)").child(self.userID!).child(date)
            v.delete { (error) in
                if let error = error {
                    // Uh-oh, an error occurred!
                    print(error.localizedDescription)

                } else {
                    print("success bitch")
                }
            }
            s.delete { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("success bitch again")
                }
            }
        })
        
        

        //DELETE STORAGE OF VIDEO AND FIRST SIGNATURE
    }
    @IBAction func record(_ sender: UIButtonX){
        takeVid()
    }
    @IBAction func confirm(_ sender: UIButtonX){
        timer.invalidate()
        failPopUpTimer.invalidate()
        
        userRef.child(userID!).updateChildValues(["ConfirmPopUp":false])
        
        userRef.child(userID!).observe(.value, with: { (snapshot) in
            let userRequesting = snapshot.childSnapshot(forPath: "RequestFromID").value as! String
            let date = snapshot.childSnapshot(forPath: "RequestDate").value as! String
            
            self.uploadSignature( completion: { (url) in
                let newRef = self.entryRef.child(userRequesting).child(self.userID!).child(date)
                newRef.updateChildValues(["secondSignature": url as Any,
                                          "Confirmed": true])
            })
        })
        
        addEntryToDatabase()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIButtonX){
        
        userRef.child(userID!).observe(.value, with: { (snapshot) in
            let userRequesting = snapshot.childSnapshot(forPath: "RequestFromID").value as! String
            self.userRef.child(userRequesting).updateChildValues(["FailPopUp":true])
        })
        userRef.child(userID!).updateChildValues(["ConfirmPopUp":false])
        deleteEntryDueToCancellation()
        
        dismiss(animated: true, completion: nil)
    }
}

extension SecondConfirmConsentPopUp: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
        let vidRef = Storage.storage().reference(forURL: "gs://consent-bc442.appspot.com/").child("consent_vids").child("user/\(uid)").child("\(otherUID)").child(Constants.dateUsed + "2")
        
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
            vidController.cameraDevice = .front
            
            self.present(vidController, animated: true, completion: nil)
        }else{
            let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
            
            let nextVC = sb.instantiateViewController(withIdentifier: "Error")
            Constants.ErrorType = .CamE
            self.present(nextVC, animated:true, completion:nil)
        }
    }
}


