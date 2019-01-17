//
//  UIGradientLabel.swift
//  UIAPI
//
//  Created by Shahar Ben-Dor on 10/25/18.
//  Copyright © 2018 Velocity. All rights reserved.
//

import UIKit

class UIGradientLabel: UIView {
    let label = UILabel()
    
    override func draw(_ rect: CGRect) {
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.frame = bounds
        label.sizeToFit()
        label.frame.origin.x = 0
        label.frame.size.width = bounds.width
        label.textAlignment = labelHorizontalAlignment
        
        switch labelVerticalAlignment {
        case .top:
            label.frame.origin.y = 0
        case .middle:
            label.frame.origin.y = (frame.height - label.frame.height) / 2
        case .bottom:
            label.frame.origin.y = frame.height - label.frame.height
        }
        
        mask = label
    }
    
    // MARK: - Label
    
    @IBInspectable var labelText: String = "" {
        didSet {
            label.text = labelText
        }
    }
    
    var labelFontSize: CGFloat = 35 {
        didSet {
            label.font = UIFont(name: labelFontName, size: labelFontSize)
        }
    }
    
    @IBInspectable var defaultLabelFontSize: CGFloat = 35 {
        didSet {
            labelFontSize = defaultLabelFontSize
        }
    }
    
    @IBInspectable var labelFontName: String = "AvenirNext-Regular" {
        didSet {
            label.font = UIFont(name: labelFontName, size: labelFontSize)
        }
    }
    
    @IBInspectable var labelHorizontalAlignmentFromInt: Int = 0 {
        didSet {
            labelHorizontalAlignment = NSTextAlignment(rawValue: labelHorizontalAlignmentFromInt) ?? NSTextAlignment(rawValue: 0)!
        }
    }
    
    var labelHorizontalAlignment: NSTextAlignment = NSTextAlignment.left {
        didSet {
            label.textAlignment = labelHorizontalAlignment
        }
    }
    
    enum VerticalAlignment: Int {
        case top = 0
        case middle = 1
        case bottom = 2
    }
    
    var labelVerticalAlignment: VerticalAlignment = .middle {
        didSet {
            switch labelVerticalAlignment {
            case .top:
                label.frame.origin.y = 0
            case .middle:
                label.frame.origin.y = (frame.height - label.frame.height) / 2
            case .bottom:
                label.frame.origin.y = frame.height - label.frame.height
            }
        }
    }
    
    @IBInspectable var labelVerticalAlignmentFromInt: Int = 0 {
        didSet {
            labelVerticalAlignment = VerticalAlignment(rawValue: labelVerticalAlignmentFromInt) ?? VerticalAlignment(rawValue: 0)!
        }
    }
    
    // MARK: - Shadow Text Properties
    
    @IBInspectable var shadowOpacity: Float = 0
    
    @IBInspectable var shadowColor: UIColor = UIColor.black
    
    @IBInspectable var shadowRadius: CGFloat = 0
    
    @IBInspectable var shadowOffset: CGPoint = CGPoint(x: 0, y: 0)
    
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
}
