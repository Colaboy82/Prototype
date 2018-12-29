//
//  SignUpVC.swift
//  Consent
//
//  Created by Grumpy1211 on 10/8/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nextB: UIButtonX!
    @IBOutlet weak var backB: UIButtonX!
    
    @IBOutlet weak var pg1View: UIViewX!
    @IBOutlet weak var pg2View: UIViewX!
    @IBOutlet weak var pg3View: UIViewX!
    @IBOutlet weak var pg4View: UIViewX!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarLbl: UILabelX!
    
    var currentPg = 1.0
    var timer: Timer!
    
    weak var pg1: Pg1View!
    weak var pg2: Pg2View!
    weak var pg3: Pg3View!
    weak var pg4: Pg4View!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        pg1 = pg1View as? Pg1View
        pg2 = pg2View as? Pg2View
        pg3 = pg3View as? Pg3View
        pg4 = pg4View as? Pg4View
        
        progressBar.setProgress(0, animated: true)
        
        self.view.layer.borderColor = #colorLiteral(red: 0.7607843137, green: 0.7647058824, blue: 0.7725490196, alpha: 1)
        self.view.layer.borderWidth = 2
        
        SetFuncs.setTextFields(field: pg1.email)
        SetFuncs.setTextFields(field: pg1.pw)
        SetFuncs.setTextFields(field: pg1.pwConfirm)
        
        SetFuncs.setTextFields(field: pg2.firstName)
        SetFuncs.setTextFields(field: pg2.middleName)
        SetFuncs.setTextFields(field: pg2.lastName)
        SetFuncs.setTextFields(field: pg2.phoneNum)
        
        SetFuncs.setTextFields(field: pg3.otherText)
        SetFuncs.setButtonImg(btn: pg3.maleB, image: UIImage(named: "UncheckedBox.png")!)
        SetFuncs.setButtonImg(btn: pg3.femaleB, image: UIImage(named: "UncheckedBox.png")!)
        SetFuncs.setButtonImg(btn: pg3.otherB, image: UIImage(named: "UncheckedBox.png")!)
        
        SetFuncs.setButton(btn: pg4.resendB, color: #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1))
        
        setupPgViews(view: pg1View)
        setupPgViews(view: pg2View)
        setupPgViews(view: pg3View)
        setupPgViews(view: pg4View)
        
        backB.isHidden = false
        setPage(currPg: Float(currentPg))
        
        SetFuncs.setButton(btn: nextB, color: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
    }
    @objc func enableNextBtn(){
        if(shouldEnableNext()){
            nextB.layer.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
        }else{
            nextB.layer.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
        nextB.isEnabled = shouldEnableNext()
    }
    func setupPgViews(view:UIViewX!){
        view.layer.cornerRadius = 20
    }
    func setPage(currPg: Float){
        if(currPg == 4.0){
            pg4View.isHidden = false
            pg3View.isHidden = true
            pg2View.isHidden = true
            pg1View.isHidden = true
            backB.isHidden = true
            
            timer.invalidate()
        }else if(currPg == 3.0){
            pg4View.isHidden = true
            pg3View.isHidden = false
            pg2View.isHidden = true
            pg1View.isHidden = true

        }else if(currPg == 2.0){
            pg4View.isHidden = true
            pg3View.isHidden = true
            pg2View.isHidden = false
            pg1View.isHidden = true
            
        }else if(currPg == 1.0){
            pg4View.isHidden = true
            pg3View.isHidden = true
            pg2View.isHidden = true
            pg1View.isHidden = false
            
            pg1.email.text = ""
            pg1.pw.text = ""
            pg1.pwConfirm.text = ""
            
            pg1.checkL.image = UIImage.init(named: "flag.png")
            pg1.checkU.image = UIImage.init(named: "flag.png")
            pg1.checkM.image = UIImage.init(named: "flag.png")
            
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SignUpVC.enableNextBtn), userInfo: nil, repeats: true)
        }else{
            timer.invalidate()
            
            let sb = UIStoryboard(name: "SignUp", bundle:nil)
            
            let nextVC = sb.instantiateViewController(withIdentifier: "LoginVC")
            self.present(nextVC, animated:true, completion:nil)
        }
        
        progressBar.progress = currPg/4
        progressBar.setProgress(progressBar.progress, animated: true)
        progressBarLbl.text = String(Int(currPg)) + " / 4"
    }
    
    func checkPW(PW: String, PWC: String) -> Bool{
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let capTest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = capTest.evaluate(with: PW)
        
        if(PW.count > 8){
            pg1.checkL.image = UIImage.init(named: "checked.png")
        }
        if(capitalresult){
            pg1.checkU.image = UIImage.init(named: "checked.png")
        }
        if(PW.elementsEqual(PWC) && !(PW.isEmpty)){
            pg1.checkM.image = UIImage.init(named: "checked.png")
        }else{
            pg1.checkM.image = UIImage.init(named: "flag.png")
        }
        
        if(PW.count <= 8){
            pg1.checkL.image = UIImage.init(named: "flag.png")
            return false
        }else if(!capitalresult){
            pg1.checkU.image = UIImage.init(named: "flag.png")
            return false
        }else if(PW.isEmpty){
            pg1.checkM.image = UIImage.init(named: "flag.png")
            return false
        }else if(!PW.elementsEqual(PWC)){
            pg1.checkM.image = UIImage.init(named: "flag.png")
            return false
        }else{
            return true
        }
    }
    func shouldEnableNext() -> Bool {
        if currentPg == 1.0 {
            if let emailField = pg1.email.text {
                if emailField.isEmpty || AccountValidation.isValidEmail(email: emailField) == false {
                    return false
                }
            } else {
                return false
            }
            return checkPW(PW: pg1.pw.text!, PWC: pg1.pwConfirm.text!)
        } else if currentPg == 2.0 {
            guard let first = pg2.firstName.text, !first.isEmpty, let last = pg2.lastName.text, !last.isEmpty, let phone = pg2.phoneNum.text, !phone.isEmpty, AccountValidation.validatePhoneNum(value: phone) == false, phone.count == 10, Int64(phone) != nil else {
                return false
            }
            return true
        } else if currentPg == 3.0 {
            if !pg3.isGenderSelected() {
                return false
            }
            return true
        }
        return false
    }
    
    @IBAction func next(_ sender: Any){
        currentPg+=1.0
        setPage(currPg: Float(currentPg))
    }
    
    @IBAction func back(_ sender: Any){
        if(currentPg == 2.0){
            setPage(currPg: 1.0)
            currentPg-=1.0
        }else if(currentPg == 3.0){
            setPage(currPg: 2.0)
            currentPg-=1.0
        }else if(currentPg == 4.0){
            backB.isHidden = true
        }else{
            let sb = UIStoryboard(name: "SignUp", bundle:nil)
            timer?.invalidate()
            
            let nextVC = sb.instantiateViewController(withIdentifier: "LoginVC")
            self.present(nextVC, animated:true, completion:nil)
        }
    }
    
    //Pg4 View IBAction
    @IBAction func resendConfirmation(_ sender: UIButtonX){
        pg4.resendB.isHidden = true
        let sb = UIStoryboard(name: "PopUpTemplate", bundle:nil)
        
        let nextVC = sb.instantiateViewController(withIdentifier: "Success")
        successType.SuccessType = SuccessPopUp.SuccessType.REmail
        //SuccessPopUp.init().setSuccessType(type: SuccessPopUp.SuccessType.RPW)
        self.present(nextVC, animated:true, completion:nil)
    }
}

class Pg1View: UIViewX {
    //Pg 1
    @IBOutlet weak var email: UITextFieldX!
    @IBOutlet weak var pw: UITextFieldX!
    @IBOutlet weak var pwConfirm: UITextFieldX!
    
    @IBOutlet weak var lengthE: UILabelX!
    @IBOutlet weak var upperE: UILabelX!
    @IBOutlet weak var matchE: UILabelX!
    @IBOutlet weak var checkL: UIImageViewX!
    @IBOutlet weak var checkU: UIImageViewX!
    @IBOutlet weak var checkM: UIImageViewX!
}

class Pg2View: UIViewX {
    @IBOutlet weak var firstName: UITextFieldX!
    @IBOutlet weak var middleName: UITextFieldX!
    @IBOutlet weak var lastName: UITextFieldX!
    @IBOutlet weak var phoneNum: UITextFieldX!
}

class Pg3View: UIViewX{
    @IBOutlet weak var maleB: UIButtonX!
    @IBOutlet weak var femaleB: UIButtonX!
    @IBOutlet weak var otherB: UIButtonX!
    @IBOutlet weak var otherText: UITextFieldX!
    @IBOutlet weak var maleLbl: UILabelX!
    @IBOutlet weak var femaleLbl: UILabelX!
    @IBOutlet weak var otherLbl: UILabelX!
    @IBOutlet weak var genderLbl: UILabelX!
    
    func setGenderBtnPic(){
        if(otherB.isSelected == true){
            SetFuncs.setButtonImg(btn: maleB, image: UIImage(named: "UncheckedBox.png")!)
            SetFuncs.setButtonImg(btn: femaleB, image: UIImage(named: "UncheckedBox.png")!)
            SetFuncs.setButtonImg(btn: otherB, image: UIImage(named: "CheckedBox.png")!)
        }else if(maleB.isSelected == true){
            SetFuncs.setButtonImg(btn: maleB, image: UIImage(named: "CheckedBox.png")!)
            SetFuncs.setButtonImg(btn: femaleB, image: UIImage(named: "UncheckedBox.png")!)
            SetFuncs.setButtonImg(btn: otherB, image: UIImage(named: "UncheckedBox.png")!)
        }else if(femaleB.isSelected == true){
            SetFuncs.setButtonImg(btn: maleB, image: UIImage(named: "UncheckedBox.png")!)
            SetFuncs.setButtonImg(btn: femaleB, image: UIImage(named: "CheckedBox.png")!)
            SetFuncs.setButtonImg(btn: otherB, image: UIImage(named: "UncheckedBox.png")!)
        }else{
            SetFuncs.setButtonImg(btn: maleB, image: UIImage(named: "UncheckedBox.png")!)
            SetFuncs.setButtonImg(btn: femaleB, image: UIImage(named: "UncheckedBox.png")!)
            SetFuncs.setButtonImg(btn: otherB, image: UIImage(named: "UncheckedBox.png")!)
        }
    }
    func isGenderSelected() -> Bool{
        let male = maleB.isSelected
        let female = femaleB.isSelected
        let other = otherB.isSelected
        
        if male == true {
            return true
        }else if female == true{
            return true
        }else if other == true{
            guard let otherText = otherText.text, !otherText.isEmpty else{
                return false
            }
            return true
        }
        return false
    }
    func updateSelects(pressed: UIButtonX){
        if(pressed.isEqual(otherB)){
            otherB.isSelected = true
            maleB.isSelected = false
            femaleB.isSelected = false
        }else if(pressed.isEqual(maleB)){
            maleB.isSelected = true
            femaleB.isSelected = false
            otherB.isSelected = false
        }else if(pressed.isEqual(femaleB)){
            femaleB.isSelected = true
            maleB.isSelected = false
            otherB.isSelected = false
        }
    }
    
    @IBAction func setGender(_ sender: UIButtonX){
        sender.isSelected = !sender.isSelected
        updateSelects(pressed: sender)
        setGenderBtnPic()
    }
}

class Pg4View: UIViewX{
    @IBOutlet weak var resendB: UIButtonX!
    
}
