//
//  UniversalVar.swift
//  Consent
//
//  Created by Grumpy1211 on 12/27/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import Foundation

class Main {
    
    var SuccessType: SuccessPopUp.SuccessType
    
    init(successType: SuccessPopUp.SuccessType) {
        self.SuccessType = successType
    }
}
var successType = Main(successType: SuccessPopUp.SuccessType.null)
