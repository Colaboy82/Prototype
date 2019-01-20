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

class MainVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mainMenuB: UIButtonX!
    @IBOutlet weak var infoB: UIButtonX!
    @IBOutlet weak var profileB: UIButtonX!
    @IBOutlet weak var addEntryB: UIButtonX!
    
    @IBOutlet weak var searchBar: UITextFieldX!
    @IBOutlet weak var searchTypeB: UIButtonX!
    @IBOutlet weak var tableViewU: UITableViewX!
    
    @IBOutlet weak var searchView: UIViewX!
    
    var infoBCenter: CGPoint!
    var profileBCenter: CGPoint!
    var addEntryBCenter: CGPoint!
    
    var timer: Timer!
    var counter = 0
    
    var nameType = false
    
    //Firebase properties
    let uid = Auth.auth().currentUser?.uid.trunc(length: SetFuncs.uidCharacterLength)
    var userRef = Database.database().reference().child("users")
    var entryRef = Database.database().reference().child("ConsentEntries")
    var profilePicRef = Storage.storage().reference(forURL: "gs://consent-bc442.appspot.com/").child("profile_images")
    
    var entriesList = [ConsentEntryModel]()
    var filteredEntriesList = [ConsentEntryModel]()
    var dateList = [String]()
    var nameList = [String]()
    var filteredList = [String]()
    var filtered = false
    
    var searchedArray:[String] = Array()
    
    @IBOutlet weak var topSearchBarConstraint: NSLayoutConstraint!
    var initialTopBarConstraint: CGFloat!
    
    @IBOutlet weak var topTableViewConstraint: NSLayoutConstraint!
    var initalTopTableViewConstraint: CGFloat!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.initialTopBarConstraint = self.topSearchBarConstraint.constant
        self.initalTopTableViewConstraint = self.topTableViewConstraint.constant
        
        DispatchQueue.global(qos: .userInteractive).async {
            //background thread
            
            DispatchQueue.main.async {
                //UI thread
                self.firebasePropertiesIntializer()
                
                SetFuncs.setTextFields(field: self.searchBar, img: #imageLiteral(resourceName: "SearchIcon"))
                SetFuncs.setButton(btn: self.searchTypeB, color: #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1))
                
                self.tableViewU.dataSource = self
                self.tableViewU.delegate = self
                
                self.mainMenuB.setRounded()
                self.mainMenuB.isSelected = false
                
                self.infoB.alpha = 0
                self.profileB.alpha = 0
                self.addEntryB.alpha = 0
                
                self.loadData()
                self.searchBar.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
                
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {
                    timer in
                    
                    self.backgroundChecker(timer: timer)
                }
            }
        }
    }
    func firebasePropertiesIntializer(){
        userRef = userRef.child(uid!)
        entryRef = entryRef.child(uid!)
        profilePicRef = profilePicRef.child("user/\(uid!)")
    }
    func checkForConfirmPopUp(){
        if Auth.auth().currentUser != nil {
        
            let user = Auth.auth().currentUser?.uid.trunc(length: 10)
            let userRef = Database.database().reference().child("users").child(user!).child("ConfirmPopUp")
                
            userRef.observeSingleEvent(of: .value, with: {(snapshot) in
                let bool = snapshot.value as! Bool
                if(bool == true){
                    let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
                    let nextVC = sb.instantiateViewController(withIdentifier: "SecondConfirmConsent")
                    nextVC.modalTransitionStyle = .crossDissolve
                    self.timer.invalidate()
                    self.present(nextVC, animated:true, completion:nil)
                }
            })
        }
    }
    func checkFailPopUp(){
        let userRefFail = Database.database().reference().child("users").child(uid!).child("FailPopUp")
        
        //guard let uid = Auth.auth().currentUser?.uid.trunc(length: SetFuncs.uidCharacterLength) else { return }
        userRefFail.observeSingleEvent(of: .value, with: {(snapshot) in
            guard let bool = snapshot.value as? Bool else { return }
            
            if bool == true {
                let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
                
                let nextVC = sb.instantiateViewController(withIdentifier: "Error")
                Constants.ErrorType = .SubmitFail
                nextVC.modalTransitionStyle = .crossDissolve
                self.timer.invalidate()
                self.present(nextVC, animated:true, completion:nil)
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
    func backgroundChecker(timer:Timer) {
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            //print("do some background task")
            self.checkForConfirmPopUp()
            self.checkFailPopUp()
            //self.updateData()
            DispatchQueue.main.async {
                //print("update some UI")
            }
        }
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
        let sb = UIStoryboard(name: "InfoPage", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "InfoPage")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
    @IBAction func profileBClicked(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "ProfilePage", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "ProfilePage")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
    @IBAction func addEntryBClicked(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "AddEntry", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "AddEntry")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
    @IBAction func switchSearchType(_ sender: UIButtonX){
        if(nameType){
            sender.setTitle("Name", for: .normal)
        }else if !nameType{
            sender.setTitle("Date", for: .normal)
        }
        nameType = !nameType
        searchBar.text = ""
    }

}

//parsing and getting Firebase Data
extension MainVC {
    
    func loadData(){
        entryRef.observe(.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.entriesList.removeAll()
                
                //iterating through all the values
                for entries in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let entries = entries.value as? [String: AnyObject] ?? [String: AnyObject]()
                    for data in entries {
                        let entry = data.value as! [String: AnyObject]
                        
                        let agreedActions = entry["AgreedActions"] as! String
                        let confirmed = entry["Confirmed"] as! Bool
                        let userID = entry["UserID"] as! String
                        var date = entry["Date"] as! String
                        let fSign = entry["FirstSignature"] as! String
                        let sSign = entry["secondSignature"] as! String
                        let profileUrl = entry["ProfilePic"] as! String
                        let vidUrl = entry["VidUrl"] as! String
                        let email = entry["email"] as! String
                        let firstName = entry["firstName"] as! String
                        let midName = entry["middleName"] as! String
                        let lastName = entry["lastName"] as! String
                        let phoneNum = entry["phoneNum"] as! String
                        let gender = entry["gender"] as! String
                        
                        //creating artist object with model and fetched values
                        let eachEntry = ConsentEntryModel.init(user: Auth.auth().currentUser!, date: date, otherUserID: userID, vidUrl: vidUrl, email: email, firstName: firstName, midName: midName, lastName: lastName, phoneNum: phoneNum, gender: gender, profilePicUrl: profileUrl, agreedActions: agreedActions, firstSignature: fSign, secondSignature: sSign)
                        
                        //populate search arrrays
                        let name = firstName + " " + lastName
                        self.nameList.append(name)
                        
                        if let commaRange = date.range(of: ",") {
                            date.removeSubrange(commaRange.lowerBound..<date.endIndex)
                        }
                        self.dateList.append(date)
                        
                        if (confirmed == true){
                            //adding it to list
                            self.entriesList.insert(eachEntry, at: 0)
                        }
                    }
                }
                self.filteredEntriesList = self.entriesList
                //reloading the tableview
                self.tableViewU.reloadData()
            }
        })
    }
    
    func updateData(){
        entryRef.observe(.childChanged, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.entriesList.removeAll()
                
                //iterating through all the values
                for entries in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let entries = entries.value as? [String: AnyObject] ?? [String: AnyObject]()
                    for data in entries {
                        let entry = data.value as! [String: AnyObject]
                        
                        let agreedActions = entry["AgreedActions"] as! String
                        let confirmed = entry["Confirmed"] as! Bool
                        let userID = entry["UserID"] as! String
                        let date = entry["Date"] as! String
                        let fSign = entry["FirstSignature"] as! String
                        let sSign = entry["secondSignature"] as! String
                        let profileUrl = entry["ProfilePic"] as! String
                        let vidUrl = entry["VidUrl"] as! String
                        let email = entry["email"] as! String
                        let firstName = entry["firstName"] as! String
                        let midName = entry["middleName"] as! String
                        let lastName = entry["lastName"] as! String
                        let phoneNum = entry["phoneNum"] as! String
                        let gender = entry["gender"] as! String
                        
                        //creating artist object with model and fetched values
                        let eachEntry = ConsentEntryModel.init(user: Auth.auth().currentUser!, date: date, otherUserID: userID, vidUrl: vidUrl, email: email, firstName: firstName, midName: midName, lastName: lastName, phoneNum: phoneNum, gender: gender, profilePicUrl: profileUrl, agreedActions: agreedActions, firstSignature: fSign, secondSignature: sSign)
                        
                        if (confirmed == true){
                            //adding it to list
                            self.entriesList.insert(eachEntry, at: 0)
                        }
                    }
                }
                //reloading the tableview
                self.tableViewU.reloadData()
            }
        })
    }
}
