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
    @IBOutlet weak var tableViewU: UITableView!

    var userRef = Database.database().reference()
    var profilePicRef = Storage.storage().reference()
    
    var infoBCenter: CGPoint!
    var profileBCenter: CGPoint!
    var addEntryBCenter: CGPoint!
    
    var timer: Timer!
    var counter = 0
    
    var nameType = true
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        DispatchQueue.global(qos: .userInteractive).async {
            //background thread
            DispatchQueue.main.async {
                //UI thread
                /*self.testImage.setRounded()
                self.testImage.borderWidth = 1
                self.testImage.borderColor = #colorLiteral(red: 0.7607843137, green: 0.7647058824, blue: 0.7725490196, alpha: 1)
                self.testImage.contentMode = .scaleAspectFill*/
                
                SetFuncs.setTextFields(field: self.searchBar, img: #imageLiteral(resourceName: "SearchIcon.png"))
                SetFuncs.setButton(btn: self.searchTypeB, color: #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1))
                
                self.tableViewU.dataSource = self
                
                self.mainMenuB.setRounded()
                self.mainMenuB.isSelected = false
                
                self.infoB.alpha = 0
                self.profileB.alpha = 0
                self.addEntryB.alpha = 0
                
            }
        }
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
        if(!nameType){
            sender.setTitle("Date", for: .normal)
        }else if nameType{
            sender.setTitle("Name", for: .normal)
        }
        nameType = !nameType
    }

}

