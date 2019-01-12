//
//  SecondConfirmConsentPopUp.swift
//  Consent
//
//  Created by Grumpy1211 on 1/9/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase

class SecondConfirmConsentPopUp: UIViewController, YPSignatureDelegate {
    
    @IBOutlet weak var confirmBtn: UIButtonX!
    @IBOutlet weak var cancelBtn: UIButtonX!
    @IBOutlet weak var profilePic: UIImageViewX!
    
    @IBOutlet weak var nameLbl: UILabelX!
    @IBOutlet weak var genderLbl: UILabelX!
    @IBOutlet weak var agreeLbl: UILabelX!
    @IBOutlet weak var signatureView: YPDrawSignatureView!
    
    @IBOutlet weak var popUpView: UIViewX!
    
    var timer: Timer!
    
    var userID = Auth.auth().currentUser?.uid.trunc(length: 10)
    var userRef = Database.database().reference().child("users")
    var entryRef = Database.database().reference().child("ConsentEntries")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(shouldEnable), userInfo: nil, repeats: true)
    }
    
    func setUp(){
        SetFuncs.setButton(btn: confirmBtn, color:#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
        confirmBtn.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        profilePic.setRounded()
        profilePic.borderWidth = 1
        profilePic.borderColor = #colorLiteral(red: 0.7607843137, green: 0.7647058824, blue: 0.7725490196, alpha: 1)
        profilePic.contentMode = .scaleAspectFill
        
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
    @objc func shouldEnable(){
        if (signatureView.doesContainSignature){
            confirmBtn.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
            confirmBtn.isEnabled = true
        } else {
            confirmBtn.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            confirmBtn.isEnabled = false
        }
    }
    func uploadSignature(completion: @escaping (_ url: String?) -> ()){
        guard let uid = Auth.auth().currentUser?.uid.trunc(length: SetFuncs.uidCharacterLength) else { return }
        
        userRef.child(uid).child("RequestFromID").observeSingleEvent(of: .value, with: { (snapshot) in
            let userRequesting = snapshot.value as! String
            
            let sigRef = Storage.storage().reference(forURL: "gs://consent-bc442.appspot.com/").child("consent_signatures").child("user/\(userRequesting)").child("\(uid)").child(SetFuncs.getFirebaseDate() + "Second")
        
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
                    e.createEntry()
                
                    let newRef = self.entryRef.child(self.userID!).child(entryArray[2] as! String).child(date)
                    newRef.updateChildValues(["Confirmed": true])
                })
            })
        })
    }
    @IBAction func confirm(_ sender: UIButtonX){
        timer.invalidate()
        
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
        
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "MainVC")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
    
    @IBAction func cancel(_ sender: UIButtonX){
        
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
        
        
        dismiss(animated: true, completion: nil)
    }
}

