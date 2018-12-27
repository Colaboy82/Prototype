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
    
    @IBOutlet weak var nextB: UIButton!
    @IBOutlet weak var backB: UIButton!
    
    @IBOutlet weak var pg1View: UIView!
    @IBOutlet weak var pg2View: UIView!
    @IBOutlet weak var pg3View: UIView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarLbl: UILabel!
    
    var currentPg = 1.0
    var timer: Timer!
    var textField = TextField.init()
    var button = Button.init()
    
    //Pg 1
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pw: UITextField!
    @IBOutlet weak var pwConfirm: UITextField!
    
    @IBOutlet weak var lengthE: UILabel!
    @IBOutlet weak var upperE: UILabel!
    @IBOutlet weak var matchE: UILabel!
    @IBOutlet weak var checkL: UIImageView!
    @IBOutlet weak var checkU: UIImageView!
    @IBOutlet weak var checkM: UIImageView!
    
    //Pg 2
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var middleName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNum: UITextField!
    
    //Pg 3
    
    
    override func viewDidLoad() {
        progressBar.setProgress(0, animated: true)
        
        self.view.layer.borderColor = #colorLiteral(red: 0.7607843137, green: 0.7647058824, blue: 0.7725490196, alpha: 1)
        self.view.layer.borderWidth = 2
        
        textField.setTextFields(field: firstName)
        textField.setTextFields(field: middleName)
        textField.setTextFields(field: lastName)
        textField.setTextFields(field: phoneNum)
        
        textField.setTextFields(field: email)
        textField.setTextFields(field: pw)
        textField.setTextFields(field: pwConfirm)
        
        setupPgViews(view: pg1View)
        setupPgViews(view: pg2View)
        setupPgViews(view: pg3View)
        
        backB.isHidden = false
        setPage(currPg: Float(currentPg))
        
        button.setButton(btn: nextB, color: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1))
        
        super.viewDidLoad()
    }
    @objc func enableNextBtn(){
        if(shouldEnableNext()){
            nextB.layer.backgroundColor = #colorLiteral(red: 0.2078431373, green: 0.3647058824, blue: 0.4901960784, alpha: 1)
        }else{
            nextB.layer.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
        nextB.isEnabled = shouldEnableNext()
    }
    func setupPgViews(view:UIView!){
        view.layer.cornerRadius = 20
    }
    func setPage(currPg: Float){
        if(currPg == 3.0){
            pg3View.isHidden = false
            pg2View.isHidden = true
            pg1View.isHidden = true
            backB.isHidden = true
            
            timer.invalidate()
        }else if(currPg == 2.0){
            pg3View.isHidden = true
            pg2View.isHidden = false
            pg1View.isHidden = true
            
        }else if(currPg == 1.0){
            pg3View.isHidden = true
            pg2View.isHidden = true
            pg1View.isHidden = false
            
            email.text = ""
            pw.text = ""
            pwConfirm.text = ""
            
            checkL.image = UIImage.init(named: "flag.png")
            checkU.image = UIImage.init(named: "flag.png")
            checkM.image = UIImage.init(named: "flag.png")
            
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SignUpVC.enableNextBtn), userInfo: nil, repeats: true)
        }else{
            timer.invalidate()
            
            let sb = UIStoryboard(name: "SignUp", bundle:nil)
            
            let nextVC = sb.instantiateViewController(withIdentifier: "LoginVC")
            self.present(nextVC, animated:true, completion:nil)
        }
        
        progressBar.progress = currPg/3
        progressBar.setProgress(progressBar.progress, animated: true)
        progressBarLbl.text = String(Int(currPg)) + " / 3"
    }
    
    func checkPW(PW: String, PWC: String) -> Bool{
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let capTest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = capTest.evaluate(with: PW)
        
        if(PW.count > 8){
            checkL.image = UIImage.init(named: "checked.png")
        }
        if(capitalresult){
            checkU.image = UIImage.init(named: "checked.png")
        }
        if(PW.elementsEqual(PWC) && !(PW.isEmpty)){
            checkM.image = UIImage.init(named: "checked.png")
        }else{
            checkM.image = UIImage.init(named: "flag.png")
        }
        
        if(PW.count <= 8){
            checkL.image = UIImage.init(named: "flag.png")
            return false
        }else if(!capitalresult){
            checkU.image = UIImage.init(named: "flag.png")
            return false
        }else if(PW.isEmpty){
            checkM.image = UIImage.init(named: "flag.png")
            return false
        }else if(!PW.elementsEqual(PWC)){
            checkM.image = UIImage.init(named: "flag.png")
            return false
        }else{
            return true
        }
    }
    func shouldEnableNext() -> Bool {
        if currentPg == 1.0 {
            if let emailField = email.text {
                if emailField.isEmpty || AccountValidation.isValidEmail(email: emailField) == false {
                    return false
                }
            } else {
                return false
            }
            return checkPW(PW: pw.text!, PWC: pwConfirm.text!)
        } else if currentPg == 2.0 {
            guard let first = firstName.text, !first.isEmpty, let last = lastName.text, !last.isEmpty, let phone = phoneNum.text, !phone.isEmpty, phone.count == 10, Int64(phone) != nil else {
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
            backB.isHidden = true
        }else{
            let sb = UIStoryboard(name: "SignUp", bundle:nil)
            timer?.invalidate()
            
            let nextVC = sb.instantiateViewController(withIdentifier: "LoginVC")
            self.present(nextVC, animated:true, completion:nil)
        }
    }
}
