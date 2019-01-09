//
//  ConfirmConsentPopUp.swift
//  Consent
//
//  Created by Grumpy1211 on 1/4/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit
import Firebase

class ConfirmConsentPopUp: UIViewController, YPSignatureDelegate {

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
            SetFuncs.setButton(btn: confirmBtn, color:#colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1))
            confirmBtn.isEnabled = true
        } else {
            SetFuncs.setButton(btn: confirmBtn, color:#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
            confirmBtn.isEnabled = false
        }
    }
    func uploadSignature(completion: @escaping (_ url: String?) -> ()){
        let entry = AddEntryVC.entryContent!
        guard let uid = Auth.auth().currentUser?.uid.trunc(length: SetFuncs.uidCharacterLength) else { return }
        let sigRef = Storage.storage().reference(forURL: "gs://consent-bc442.appspot.com/").child("consent_signatures").child("user/\(uid)").child("\(entry[2])").child(SetFuncs.getFirebaseDate())
        
        sigRef.putData(signatureView.getPDFSignature(), metadata: nil) { (metaData, error) in
            if error == nil, metaData != nil{
                sigRef.downloadURL(completion: { (url, error) in
                    completion(url?.absoluteString)
                })
            }else{
                print(error?.localizedDescription as Any)
                completion(nil)
            }
        }
    }
    @IBAction func confirm(_ sender: UIButtonX){
        timer.invalidate()
        
        let entry = AddEntryVC.entryContent!
        let main = AddEntryVC()
        main.uploadVid(vidURL: entry[12] as! URL)
        
        uploadSignature( completion: { (url) in
            let e = ConsentEntryModel.init(user: entry[0] as! User,
                                           date: entry[1] as! String,
                                           otherUserID: entry[2] as! String,
                                           vidUrl: entry[3] as! String,
                                           email: entry[4] as! String,
                                           firstName: entry[5] as! String,
                                           midName: entry[6] as! String,
                                           lastName: entry[7] as! String,
                                           phoneNum: entry[8] as! String,
                                           gender: entry[9] as! String,
                                           profilePicUrl: entry[10] as! String,
                                           agreedActions: entry[11] as! String,
                                           firstSignature: url!,
                                           secondSignature: "")
            e.createEntry()
        
        })
        
        //dismiss(animated: true, completion: nil)
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "MainVC")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
    
    @IBAction func cancel(_ sender: UIButtonX){
        dismiss(animated: true, completion: nil)
    }
}
