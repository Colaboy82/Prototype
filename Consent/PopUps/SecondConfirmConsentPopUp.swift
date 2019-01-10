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
    }
    
    @objc func shouldEnable(){
        if (signatureView.doesContainSignature){
            confirmBtn.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
            confirmBtn.isEnabled = true
        } else {
            confirmBtn.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
            confirmBtn.isEnabled = false
        }
    }
    func uploadSignature(completion: @escaping (_ url: String?) -> ()){
        guard let uid = Auth.auth().currentUser?.uid.trunc(length: SetFuncs.uidCharacterLength) else { return }
        let userRef = Database.database().reference().child("users")
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
    @IBAction func confirm(_ sender: UIButtonX){
        timer.invalidate()
        let userID = Auth.auth().currentUser?.uid.trunc(length: 10)
        let userRef = Database.database().reference().child("users")
        let entryRef = Database.database().reference().child("ConsentEntries")
        
        userRef.child(userID!).updateChildValues(["ConfirmPopUp":false])

        userRef.child(userID!).observe(.value, with: { (snapshot) in
            let userRequesting = snapshot.childSnapshot(forPath: "RequestFromID").value as! String
            let date = snapshot.childSnapshot(forPath: "RequestDate").value as! String
            
            self.uploadSignature( completion: { (url) in
                let newRef = entryRef.child(userRequesting).child(userID!).child(date)
                newRef.updateChildValues(["secondSignature": url as Any,
                                              "Confirmed": true])
            })
        })
        
        
        
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "MainVC")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
    
    @IBAction func cancel(_ sender: UIButtonX){
        let userID = Auth.auth().currentUser?.uid.trunc(length: 10)
        let userRef = Database.database().reference().child("users")
        let entryRef = Database.database().reference().child("ConsentEntries")
        
        userRef.child(userID!).updateChildValues(["ConfirmPopUp":false])
        
        userRef.child(userID!).observe(.value, with: { (snapshot) in
            let userRequesting = snapshot.childSnapshot(forPath: "RequestFromID").value as! String
            let date = snapshot.childSnapshot(forPath: "RequestDate").value as! String
            
            self.uploadSignature( completion: { (url) in
                let newRef = entryRef.child(userRequesting).child(userID!).child(date)
                newRef.updateChildValues(["secondSignature": url as Any,
                                          "Confirmed": true])
            })
        })
        
        
        dismiss(animated: true, completion: nil)
    }
}

