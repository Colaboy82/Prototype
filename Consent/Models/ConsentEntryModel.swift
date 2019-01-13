//
//  ConsentSubModel.swift
//  Consent
//
//  Created by Grumpy1211 on 1/2/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class ConsentEntryModel{
    let email: String
    
    let firstName: String
    let midName: String
    let lastName: String
    let phoneNum: String
    
    let gender: String
    
    let profilePicUrl: String
    let date: String
    let vidUrl: String
    
    let user: User
    let otherUserID: String
    
    let agreedActions: String
    
    let firstSignature: String
    let secondSignature: String
    
    init(user: User, date: String, otherUserID: String, vidUrl: String, email: String, firstName: String, midName: String, lastName: String, phoneNum: String, gender: String, profilePicUrl: String, agreedActions: String, firstSignature: String, secondSignature: String){
        self.user = user
        self.date = date
        self.otherUserID = otherUserID
        self.vidUrl = vidUrl
        
        self.email = email
        self.firstName = firstName
        self.midName = midName
        self.lastName = lastName
        self.phoneNum = phoneNum
        self.gender = gender
        self.profilePicUrl = profilePicUrl
        self.agreedActions = agreedActions
        
        self.firstSignature = firstSignature
        self.secondSignature = secondSignature
    }
    func createEntry(){
        let newUserRef = Database.database().reference().child("ConsentEntries").child(user.uid.trunc(length: SetFuncs.uidCharacterLength)).child("\(otherUserID)").child(SetFuncs.getFirebaseDate())
        let values = ["email": email,
                      "firstName": firstName,
                      "middleName": midName,
                      "lastName": lastName,
                      "phoneNum": phoneNum,
                      "gender": gender,
                      "ProfilePic": profilePicUrl,
                      "UserID": otherUserID,
                      "Date": date,
                      "VidUrl": vidUrl,
                      "AgreedActions": agreedActions,
                      "FirstSignature": firstSignature,
                      "secondSignature": secondSignature,
                      "Confirmed": false] as [String : Any]
        newUserRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
        })
    }
    func createDuplicateEntry(savedDate: String){
        let newUserRef = Database.database().reference().child("ConsentEntries").child(user.uid.trunc(length: SetFuncs.uidCharacterLength)).child("\(otherUserID)").child(savedDate)
        let values = ["email": email,
                      "firstName": firstName,
                      "middleName": midName,
                      "lastName": lastName,
                      "phoneNum": phoneNum,
                      "gender": gender,
                      "ProfilePic": profilePicUrl,
                      "UserID": otherUserID,
                      "Date": date,
                      "VidUrl": vidUrl,
                      "AgreedActions": agreedActions,
                      "FirstSignature": firstSignature,
                      "secondSignature": secondSignature,
                      "Confirmed": false] as [String : Any]
        newUserRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error!)
                return
            }
        })
    }
    func getOtherUserInfo(uid: String!) -> [String]{
        var profilePicUrl, otherUserID, email, firstName, midName, lastName, gender, phoneNum: String
        profilePicUrl=""; otherUserID=""; email=""; firstName=""; midName=""; lastName=""; gender=""; phoneNum=""
        let userRef = Database.database().reference().child("users").child(uid)
        userRef.observeSingleEvent(of: .value, with: {(snapshot) in
            profilePicUrl = snapshot.childSnapshot(forPath: "ProfilePic").value as! String
            otherUserID = snapshot.childSnapshot(forPath: "UserID").value as! String
            email = snapshot.childSnapshot(forPath: "email").value as! String
            firstName = snapshot.childSnapshot(forPath: "firstName").value as! String
            midName = snapshot.childSnapshot(forPath: "middleName").value as! String
            lastName = snapshot.childSnapshot(forPath: "lastName").value as! String
            gender = snapshot.childSnapshot(forPath: "gender").value as! String
            phoneNum = snapshot.childSnapshot(forPath: "phoneNum").value as! String
        })
        return [profilePicUrl, otherUserID, email, firstName, midName, lastName, gender, phoneNum]
    }
    func getUserUID() -> String{
        return user.uid
    }
    
}

