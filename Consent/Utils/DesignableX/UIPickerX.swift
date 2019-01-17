//
//  UIPickerX.swift
//  Q-Me
//
//  Created by Shahar Ben-Dor on 8/8/18.
//  Copyright © 2018 Quantum. All rights reserved.
//

import UIKit

@IBDesignable
class UIPickerX: UIPickerView {
    var originalY: CGFloat?
    var originalX: CGFloat?
    @IBInspectable var rotationAngle: CGFloat = 0 {
        didSet {
            if originalY == nil {
                originalY = frame.origin.y
            }
            
            if originalX == nil {
                originalX = frame.origin.x
            }
            
            let rads = rotationAngle * (.pi / 180)
            transform = CGAffineTransform(rotationAngle: rads)
        }
    }
    
    @IBInspectable var updateFrame: Bool = true {
        didSet {
            if updateFrame &&  (rotationAngle >= 45 && rotationAngle < 135) || (rotationAngle >= 225 && rotationAngle < 315){
                frame = CGRect(x: originalX!, y: originalY!, width: frame.height, height: frame.width)
            }
        }
    }
}
