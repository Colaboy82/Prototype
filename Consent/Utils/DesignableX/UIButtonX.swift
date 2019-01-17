//
//  UIButtonX.swift
//  UIAPI
//
//  Created by Shahar Ben-Dor on 10/23/18.
//  Copyright © 2018 Velocity. All rights reserved.
//

import UIKit

@IBDesignable
class UIButtonX: UIButton {
    var darkView = UIView()
    
    @IBInspectable var popIn: Bool = false
    @IBInspectable var popInDelay: Double = 0.2
    
    var darkViewColor = UIColor.black
    var darkViewAlpha: CGFloat = 0.5
    
    var isAnimated: Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
        darkView.layer.cornerRadius = cornerRadius
        darkView.backgroundColor = darkViewColor
        darkView.alpha = 0
        addSubview(darkView)
        darkView.contentMode = contentMode
        darkView.frame = bounds
        
        if popIn {
            transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            UIView.animate(withDuration: 0.8, delay: popInDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: { [unowned this = self] in
                this.transform = .identity
            }, completion: nil)
        }
    }
    
    lazy var defaultBackground: UIColor? = backgroundColor
    lazy var defaultBorder: UIColor = borderColor
    lazy var defaultTint: UIColor = tintColor
    var selectedColor: UIColor?
    var selectionEnabled: Bool = false
    override var isSelected: Bool {
        didSet {
            if isSelected, let selectedColor = selectedColor {
                if backgroundColor != nil {
                    backgroundColor = selectedColor
                    return
                }
                
                borderColor = selectedColor
                tintColor = selectedColor
                return
            }
            
            backgroundColor = defaultBackground
            borderColor = defaultBorder
            tintColor = defaultTint
        }
    }
    
    enum AnimationType: Int {
        case none = 0
        case lighten = 1
        case darken = 2
        case smaller = 3
        case bigger = 4
    }
    
    @IBInspectable var animationType: Int = 1
    
    private var alphaBefore: CGFloat = 1
    private var transformBefore: CGAffineTransform = .identity
    func animatePress(type: AnimationType) {
        isAnimated = true
    
        switch type {
        case .none:
            return
        case .lighten:
            alphaBefore = alpha
            alpha = alpha - 0.5
            break
        case .darken:
            darkView.alpha = darkViewAlpha
            break
        case .smaller:
            transformBefore = transform
            UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: { [weak this = self] in
                if let this = this {
                    this.transform = this.transform.scaledBy(x: 0.9, y: 0.9)
                }
            })
            break
        case .bigger:
            transformBefore = transform
            UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: { [weak this = self] in
                if let this = this {
                    this.transform = this.transform.scaledBy(x: 1.1, y: 1.1)
                }
            })
            break
        }
    }
    
    func animateRelease(type: AnimationType) {
        isAnimated = false
        
        switch type {
        case .none:
            return
        case .lighten:
            UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: { [weak this = self] in
                if let this = this {
                    this.alpha = this.alphaBefore
                }
            })
            break
        case .darken:
            UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: { [weak this = self] in
                if let this = this {
                    this.darkView.alpha = 0
                }
            })
            break
        case .smaller, .bigger:
            UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: { [weak this = self] in
                if let this = this {
                    this.transform = this.transformBefore
                }
            })
            break
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if let animation = AnimationType(rawValue: animationType) {
            animatePress(type: animation)
        }
        
        if selectionEnabled {
            isSelected = true
        }
        
        return super.beginTracking(touch, with: event)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if let animation = AnimationType(rawValue: animationType) {
            animateRelease(type: animation)
        }
        
        return super.endTracking(touch, with: event)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        if let animation = AnimationType(rawValue: animationType) {
            animateRelease(type: animation)
        }
        
        return super.cancelTracking(with: event)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchNow = touch.preciseLocation(in: self)
        
        if let animation = AnimationType(rawValue: animationType) {
            if bounds.contains(touchNow) && !isAnimated {
                animatePress(type: animation)
            } else if !bounds.contains(touchNow) && isAnimated {
                animateRelease(type: animation)
            }
        }
        
        return super.continueTracking(touch, with: event)
    }
    
    // MARK: - CornerRadius
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
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
    
    // MARK: - Borders
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
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
    
    @IBInspectable private var buttonLookFromInt: Int = 0 {
        didSet {
            look = ButtonLook(rawValue: buttonLookFromInt) ?? .custom
        }
    }
    
    var look: ButtonLook = .custom {
        didSet {
            updateLook()
        }
    }
    
    enum ButtonLook: Int {
        case custom = 0
        case filled = 1
        case outline = 2
        case gradient = 3
        case coloredText = 4
        case contrastedText = 5
        case reduceContrastText = 6
    }
    
    func updateLook() {
        if tag == -1 || tag == -2 {
            return
        }
        
        if look != .custom {
            adjustsImageWhenHighlighted = false
        }
        
        switch look {
        case .custom:
            break
        case .filled:
            backgroundColor = ColorScheme.interactive
            selectedColor = ColorScheme.interactiveD1
            tintColor = ColorScheme.darkText
            
            defaultBorder = UIColor.clear
            defaultBackground = ColorScheme.interactive
            break
        case .outline:
            backgroundColor = nil
            tintColor = ColorScheme.interactive
            setTitleColor(ColorScheme.interactive, for: .normal)
            borderColor = ColorScheme.interactive
            borderWidth = 2
            
            setTitleColor(ColorScheme.interactiveD1, for: .selected)
            selectedColor = ColorScheme.interactiveD1
            
            setTitleColor(ColorScheme.disabled, for: .disabled)
            
            defaultBorder = ColorScheme.interactive
            defaultTint = ColorScheme.interactive
            defaultBackground = nil
            break
        case .gradient:
            gradientFirstColor = ColorScheme.interactiveGradient1
            gradientSecondColor = ColorScheme.interactiveGradient2
            gradientStart = CGPoint(x: 0, y: 0)
            gradientEnd = CGPoint(x: 1, y: 1)
            break
        case .coloredText:
            setTitleColor(ColorScheme.interactive, for: .normal)
            setTitleColor(ColorScheme.disabled, for: .disabled)
            tintColor = ColorScheme.interactive
            break
        case .contrastedText:
            setTitleColor(ColorScheme.reducedHighContrast, for: .normal)
            setTitleColor(ColorScheme.disabled, for: .disabled)
            tintColor = ColorScheme.reducedHighContrast
            break
        case .reduceContrastText:
            setTitleColor(ColorScheme.reducedHighContrast, for: .selected)
            setTitleColor(ColorScheme.increasedlowContrast, for: .normal)
            setTitleColor(ColorScheme.disabled, for: .disabled)
            tintColor = ColorScheme.increasedlowContrast
            break
        }
    }
    
    public func setEnabled(_ toEnable: Bool) {
        isEnabled = toEnable
        if toEnable {
            backgroundColor = defaultBackground
            tintColor = defaultTint
            borderColor = defaultBorder
            
            updateView()
            return
        }
        
        let layer = self.layer as! CAGradientLayer
        layer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
        
        if backgroundColor != nil {
            backgroundColor = ColorScheme.disabled
            tintColor = ColorScheme.disabledTint
            return
        }
        
        borderColor = ColorScheme.disabled
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        darkView.frame = bounds
    }
}
