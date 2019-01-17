//
//  UIShadowView.swift
//  AuxPlz
//
//  Created by Shahar Ben-Dor on 11/15/18.
//  Edited by Shahar Ben-Dor
//  Copyright © 2018 Mark Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UIShadowView: UIView {
    // MARK: - Shadow
    
    @IBInspectable public var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = ColorScheme.isDark ? log(ColorScheme.shadowScalar * shadowOpacity + 1) / log(ColorScheme.shadowScalar + 1) : shadowOpacity
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.black {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 5 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffset: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            layer.shadowOffset = CGSize(width: shadowOffset.x, height: shadowOffset.y)
        }
    }
}
