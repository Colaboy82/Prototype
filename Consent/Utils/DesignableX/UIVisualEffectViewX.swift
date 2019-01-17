//
//  UIVisualEffectViewX.swift
//  DesignableXTesting
//
//  Created by Mark Moeykens on 2/3/17.
//  Edited by Shahar Ben-Dor
//  Copyright © 2017 Moeykens. All rights reserved.
//

import UIKit

class UIVisualEffectViewX: UIVisualEffectView {

    // MARK: - Border
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    // MARK: - Corner Radius
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var cornerRadiusForCorners: String = "0,1,2,3" {
        didSet {
            let cornersString = cornerRadiusForCorners.split(separator: ",")
            var masks = CACornerMask()
            for string in cornersString {
                if let num = Int(string) {
                    switch (num) {
                    case 0:
                        masks = masks.union(.layerMinXMinYCorner)
                        break
                    case 1:
                        masks = masks.union(.layerMaxXMinYCorner)
                        break
                    case 2:
                        masks = masks.union(.layerMaxXMaxYCorner)
                        break
                    case 3:
                        masks = masks.union(.layerMinXMaxYCorner)
                        break
                    default:
                        break
                    }
                }
            }
            
            layer.maskedCorners = masks
        }
    }
    
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
    
    // MARK: - View Look
    
    @IBInspectable private var viewLookFromInt: Int = 0 {
        didSet {
            look = ViewLook(rawValue: viewLookFromInt) ?? .custom
        }
    }
    
    var look: ViewLook = .custom {
        didSet {
            updateLook()
        }
    }
    
    enum ViewLook: Int {
        case custom = 0
        case bg = 1
        case highContrast = 2
        case reducedHighContrast = 3
        case increasedLowContrast = 4
        case lowContrast = 5
        case primary = 6
    }
    
    func updateLook() {
        if adaptsToDark {
            effect = ColorScheme.isDark ? UIBlurEffect(style: .dark) : defaultEffect
        }
        
        switch look {
        case .custom:
            break
        case .bg:
            backgroundColor = ColorScheme.bg
            break
        case .highContrast:
            backgroundColor = (tag >= 0 || tag <= -3) ? ColorScheme.highContrast : ColorScheme.d1
            break
        case .reducedHighContrast:
            backgroundColor = (tag >= 0 || tag <= -3) ? ColorScheme.reducedHighContrast : ColorScheme.d3
            break
        case .increasedLowContrast:
            backgroundColor = (tag >= 0 || tag <= -3) ? ColorScheme.increasedlowContrast : ColorScheme.l3
            break
        case .lowContrast:
            backgroundColor = (tag >= 0 || tag <= -3) ? ColorScheme.lowContrast : ColorScheme.l2
            break
        case .primary:
            backgroundColor = ColorScheme.primary
            break
        }
    }
    
    // MARK: - Visual Effect
    lazy var defaultEffect = effect
    
    @IBInspectable var adaptsToDark: Bool = true {
        didSet {
            updateLook()
        }
    }
    
    override func awakeFromNib() {
        updateLook()
    }
}
