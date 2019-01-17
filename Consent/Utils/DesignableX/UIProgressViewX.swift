//
//  UIProgressBarX.swift
//  Aux Plz
//
//  Created by Shahar Ben-Dor on 12/6/18.
//  Copyright © 2018 Spectre. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UIProgressViewX: UIProgressView {
    @IBInspectable var barHeight : CGFloat {
        get {
            return transform.d * 2.0
        }
        
        set {
            let heightScale = newValue / 2.0
            let c = center
            transform = CGAffineTransform(scaleX: 1, y: heightScale)
            center = c
        }
    }
}
