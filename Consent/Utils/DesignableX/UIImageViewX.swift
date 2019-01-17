//
//  UIImageViewX.swift
//  003 - Onboarding Page
//
//  Created by Mark Moeykens on 1/5/17.
//  Edited by Shahar Ben-Dor
//  Copyright © 2017 Mark Moeykens. All rights reserved.
//

import UIKit

@IBDesignable
class UIImageViewX: UIImageView {
    
    // MARK: - Properties
    
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
    
    // MARK: - Animation
    
    @IBInspectable var pulseDelay: Double = 0.0
    @IBInspectable var popIn: Bool = false
    @IBInspectable var popInDelay: Double = 0.4
    
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
    
    @IBInspectable private var imageLookFromInt: Int = 0 {
        didSet {
            look = ImageLook(rawValue: imageLookFromInt) ?? .custom
        }
    }
    
    var look: ImageLook = .custom {
        didSet {
            updateLook()
        }
    }
    
    @IBInspectable private var imageTintLookFromInt: Int = 0 {
        didSet {
            tintLook = ImageLook(rawValue: imageTintLookFromInt) ?? .custom
        }
    }
    
    var tintLook: ImageLook = .custom {
        didSet {
            updateLook()
        }
    }
    
    enum ImageLook: Int {
        case custom = 0
        case bg = 1
        case highContrast = 2
        case reducedHighContrast = 3
        case increasedLowContrast = 4
        case lowContrast = 5
        case primary = 6
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
        }
        
        switch tintLook {
        case .custom:
            break
        case .bg:
            tintColor = ColorScheme.bg
            break
        case .highContrast:
            tintColor = (tag >= 0 || tag <= -3) ? ColorScheme.highContrast : ColorScheme.d1
            break
        case .reducedHighContrast:
            tintColor = (tag >= 0 || tag <= -3) ? ColorScheme.reducedHighContrast : ColorScheme.d3
            break
        case .increasedLowContrast:
            tintColor = (tag >= 0 || tag <= -3) ? ColorScheme.increasedlowContrast : ColorScheme.l3
            break
        case .lowContrast:
            tintColor = (tag >= 0 || tag <= -3) ? ColorScheme.lowContrast : ColorScheme.l2
            break
        case .primary:
            tintColor = ColorScheme.primary
            break
        }
    }
    
    func reloadTint() {
        let oldTint = tintColor
        tintColor = .clear
        tintColor = oldTint
    }
    
    override func awakeFromNib() {
        reloadTint()
        
        if pulseDelay > 0 {
            UIView.animate(withDuration: 1, delay: pulseDelay, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: { [unowned this = self] in
                this.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                this.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
        if popIn {
            transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.8, delay: popInDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: { [unowned this = self] in
                this.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    func setImage(image: UIImage?, animationDuration: Double = 0.3) {
        self.image = image
        let transition: CATransition = CATransition()
        transition.duration = animationDuration
        transition.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        transition.type = .fade
        self.layer.add(transition, forKey: nil)
    }
}
