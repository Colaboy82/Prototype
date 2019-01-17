//
//  UIMask.swift
//  Aux Plz
//
//  Created by Shahar Ben-Dor on 12/10/18.
//  Copyright © 2018 Spectre. All rights reserved.
//

import Foundation
import UIKit

class UIMask: UIViewX {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        superview?.mask = self
    }
}
