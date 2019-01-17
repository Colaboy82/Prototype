//
//  UICollectionViewX.swift
//  Aux Plz
//
//  Created by Shahar Ben-Dor on 12/14/18.
//  Copyright © 2018 Spectre. All rights reserved.
//

import Foundation
import UIKit

class UIStackViewX: UIStackView {
    // MARK: - Gradient
    
    @IBInspectable var gradientFirstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var gradientSecondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var gradientStart: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var gradientEnd: CGPoint = CGPoint(x: 1, y: 1) {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var gradientTypeFromInt: Int = 0 {
        didSet {
            switch gradientTypeFromInt {
            case 1:
                gradientType = .radial
                break
            case 2:
                if #available(iOS 12.0, *) {
                    gradientType = .conic
                } else {
                    gradientType = .radial
                }
                break
            default:
                gradientType = .axial
                break
            }
        }
    }
    
    @IBInspectable var ignoresColorScheme: Bool = false
    
    var gradientType: CAGradientLayerType = .axial {
        didSet {
            let layer = self.layer as! CAGradientLayer
            layer.type = gradientType
        }
    }
    
    override public class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [gradientFirstColor.cgColor, gradientSecondColor.cgColor]
        
        layer.startPoint = gradientStart
        layer.endPoint = gradientEnd
    }
    
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
        case gradient = 7
    }
    
    func updateLook() {
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
        case .gradient:
            gradientFirstColor = ColorScheme.gradient1
            gradientSecondColor = ColorScheme.gradient2
            break
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
}
