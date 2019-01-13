//
//  ConsentSubModel.swift
//  Consent
//
//  Created by Grumpy1211 on 1/2/19.
//  Copyright © 2019 MuSquared. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ConsentEntryCell: UITableViewCell{
    
    @IBOutlet weak var nameLbl: UILabelX!
    
    @IBOutlet weak var dateLbl: UILabelX!
    
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var mainView: UIViewX!
    
    var consentEntry: ConsentEntryModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    func configCell(consentSubmission: ConsentEntryModel){//= nil means they do not have to have pictures
        self.consentEntry = consentSubmission
    }
}
