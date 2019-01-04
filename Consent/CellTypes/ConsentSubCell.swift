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

class ConsentSubCell: UITableViewCell{

    @IBOutlet weak var firstNameLbl: UILabelX!
    @IBOutlet weak var middleNameLbl: UILabelX!
    @IBOutlet weak var lastNameLbl: UILabelX!
    
    @IBOutlet weak var dateLbl: UILabelX!
    
    @IBOutlet weak var profilePicImg: UIImageView!
    
    var consentEntry: ConsentEntryModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    func configCell(consentSubmission: ConsentEntryModel){//= nil means they do not have to have pictures
        self.consentEntry = consentSubmission
    }
}
