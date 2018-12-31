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

class ViewController: UIViewController {
    
    @IBOutlet weak var testImage: UIImageViewX!
    
    var userRef = Database.database().reference()
    var profilePicRef = Storage.storage().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        testImage.setRounded()
        testImage.borderWidth = 1
        testImage.borderColor = #colorLiteral(red: 0.7607843137, green: 0.7647058824, blue: 0.7725490196, alpha: 1)
        testImage.contentMode = .scaleAspectFill
        
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

