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
    let midName: String
    let lastName: String
    let phoneNum: String
    
    let gender: String
    
    let user: User
    //let pic:
    
    init(email: String, pw: String, firstName: String, midName: String, lastName: String, phoneNum: String, gender: String, user: User){
        self.email = email
        self.pw = pw
        self.firstName = firstName
        self.midName = midName
        self.lastName = lastName
        self.phoneNum = phoneNum
        self.gender = gender
        self.user = user
    }
    func setValues(){
        let userRef = Database.database().reference().child("users").child(user.uid)
        let values = ["email": email,
                      "firstName": firstName,
                      "middleName": midName,
                      "lastName": lastName,
                      "phoneNum": phoneNum,
                      "gender": gender,
                      "UserID": user.uid.trunc(length: 10)]
        userRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
        })
        
    }
    
}
