//
//  UIScrollViewX.swift
//  Q-Me Remade
//
//  Created by Shahar Ben-Dor on 9/11/18.
//  Copyright © 2018 Quantum. All rights reserved.
//

import UIKit

class UIScrollViewX: UIScrollView {
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
