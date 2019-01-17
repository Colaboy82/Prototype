//
//  UITableViewX.swift
//  Aux Plz
//
//  Created by Shahar Ben-Dor on 12/2/18.
//  Copyright © 2018 Spectre. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UITableViewX: UITableView {
    @IBInspectable var topInset: CGFloat = 0 {
        didSet {
            updateInsets()
        }
    }
    
    @IBInspectable var bottomInset: CGFloat = 0 {
        didSet {
            updateInsets()
        }
    }
    
    @IBInspectable var leftInset: CGFloat = 0 {
        didSet {
            updateInsets()
        }
    }
    
    @IBInspectable var rightInset: CGFloat = 0 {
        didSet {
            updateInsets()
        }
    }
    
    private func updateInsets() {
        contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl
            && !(view is UITextInput)
            && !(view is UISlider)
            && !(view is UISwitch) {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }
}
