//
//  ContractVC.swift
//  Consent
//
//  Created by Grumpy1211 on 1/20/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import UIKit

class ContractVC: UIViewController {

    @IBOutlet weak var agreedActionsLbl: UILabelX!
    @IBOutlet weak var sig1Pic: UIImageViewX!
    @IBOutlet weak var sig2Pic: UIImageViewX!
    
    @IBOutlet weak var contractView: UIScrollViewX!
    @IBOutlet weak var exportB: UIButtonX!
    
    //For Contract
    public static var sig1Url: String!
    public static var sig2Url: String!
    public static var agreedActions: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func export(_ sender: UIButtonX){
        
    }
    @IBAction func back(_ sender: UIButtonX){
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = sb.instantiateViewController(withIdentifier: "ClickedEntry")
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated:true, completion:nil)
    }
}
