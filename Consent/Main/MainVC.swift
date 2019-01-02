//
//  ViewController.swift
//  Consent
//
//  Created by Grumpy1211 on 10/8/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainVC: UIViewController {
    
    @IBOutlet weak var testImage: UIImageViewX!
    @IBOutlet weak var mainMenuB: UIButtonX!
    @IBOutlet weak var infoB: UIButtonX!
    @IBOutlet weak var profileB: UIButtonX!
    @IBOutlet weak var addEntryB: UIButtonX!

    
    var userRef = Database.database().reference()
    var profilePicRef = Storage.storage().reference()
    
    var infoBCenter: CGPoint!
    var profileBCenter: CGPoint!
    var addEntryBCenter: CGPoint!
    
    var timer: Timer!
    var counter = 0
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        testImage.setRounded()
        testImage.borderWidth = 1
        testImage.borderColor = #colorLiteral(red: 0.7607843137, green: 0.7647058824, blue: 0.7725490196, alpha: 1)
        testImage.contentMode = .scaleAspectFill
        
        mainMenuB.setRounded()
        mainMenuB.isSelected = false
        //moveMainBtnstoMain()
        //timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(moveMainBtnstoMain), userInfo: nil, repeats: true)
        
        self.infoB.alpha = 0
        self.profileB.alpha = 0
        self.addEntryB.alpha = 0
        
        //setting references
        profilePicRef = Storage.storage().reference(forURL: "gs://consent-bc442.appspot.com/").child("profile_images").child("user/\(String(describing: Auth.auth().currentUser?.uid)))")
        userRef = userRef.child("users").child((Auth.auth().currentUser?.uid)!).child("ProfilePic")
        
        userRef.observe(.value, with: {(snapshot) in
            // Get download URL from snapshot
            let downloadURL = snapshot.value as! String
            // Create a storage reference from the URL
            let storageRef = Storage.storage().reference(forURL: downloadURL)
            // Download the data, assuming a max size of 1MB (you can change this as necessary)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                // Create a UIImage, add it to the array
                let pic = UIImage(data: data!)
                self.testImage.image = pic
            }
        })
        
    }
    override func viewDidLayoutSubviews() {
        infoBCenter = infoB.center
        profileBCenter = profileB.center
        addEntryBCenter = addEntryB.center
        
        infoB.center = mainMenuB.center
        profileB.center = mainMenuB.center
        addEntryB.center = mainMenuB.center
    }
    @IBAction func mainBClicked(_ sender: UIButtonX){
        //sender.toggleButtonImage(onImage: #imageLiteral(resourceName: "MainMenuB"), offImage: #imageLiteral(resourceName: "MainMenuB"))
        if sender.isSelected == false {
            //open buttons
            UIView.animate(withDuration: 0.3, animations: {
                self.infoB.alpha = 1
                self.profileB.alpha = 1
                self.addEntryB.alpha = 1
                
                self.infoB.center = self.infoBCenter
                self.profileB.center = self.profileBCenter
                self.addEntryB.center = self.addEntryBCenter
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.infoB.alpha = 0
                self.profileB.alpha = 0
                self.addEntryB.alpha = 0

                self.infoB.center = self.mainMenuB.center
                self.profileB.center = self.mainMenuB.center
                self.addEntryB.center = self.mainMenuB.center
            })
        }
        sender.isSelected = !sender.isSelected
    }
    @IBAction func infoBClicked(_ sender: UIButtonX){
    
    }
    @IBAction func profileBClicked(_ sender: UIButtonX){
        
    }
    @IBAction func addEntryBClicked(_ sender: UIButtonX){
        
    }
    @IBAction func signOut(){
        if Auth.auth().currentUser != nil{
            do{
                try Auth.auth().signOut()
                
                let sb = UIStoryboard(name: "SignUp", bundle:nil)
                let nextVC = sb.instantiateViewController(withIdentifier: "LoginVC")
                self.present(nextVC, animated:true, completion:nil)
                
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }


}

