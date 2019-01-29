//
//  UserModel.swift
//  Consent
//
//  Created by Grumpy1211 on 12/29/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class UserModel{
    let email: String
    let pw: String
    
    let firstName: String
    let midName: String?
    let lastName: String
    let phoneNum: String
    
    let gender: String
    
    let profilePic: String
    
    let user: User
        
    init(email: String, pw: String, firstName: String, midName: String?, lastName: String, phoneNum: String, gender: String, profilePic: String, user: User){
        self.email = email
        self.pw = pw
        self.firstName = firstName
        if (midName != nil){
            self.midName = midName
        }else{
            self.midName = ""
        }
        self.lastName = lastName
        self.phoneNum = phoneNum
        self.gender = gender
        self.user = user
        self.profilePic = profilePic
    }
    func setValues(){
        let userRef = Database.database().reference().child("users").child(user.uid.trunc(length: SetFuncs.uidCharacterLength))
        let values = ["email": email,
                      "firstName": firstName,
                      "middleName": midName,
                      "lastName": lastName,
                      "phoneNum": phoneNum,
                      "gender": gender,
                      "ProfilePic": profilePic,
                      "UserID": user.uid.trunc(length: SetFuncs.uidCharacterLength),
                      "ConfirmPopUp": false,
                      "FailPopUp": false] as [String : Any]
        userRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            self.addToUIDatabase()
            if error != nil{
                print(error!)
                return
            }
        })
    }
    func addToUIDatabase(){
        let uidRef = Database.database().reference().child("UIDatabase").child(user.uid)
        let values = ["fullUID": user.uid,
                      "shortUID": user.uid.trunc(length: SetFuncs.uidCharacterLength)] as [String : Any]
        uidRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
        })
    }
}
