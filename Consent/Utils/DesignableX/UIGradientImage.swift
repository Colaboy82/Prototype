//
//  UIGradientLabel.swift
//  UIAPI
//
//  Created by Shahar Ben-Dor on 10/25/18.
//  Copyright © 2018 Velocity. All rights reserved.
//

import UIKit

class UIGradientImage: UIView {
    let imageView = UIImageView()
    
    override func draw(_ rect: CGRect) {
        imageView.frame = bounds
        imageView.contentMode = contentMode
        imageView.clipsToBounds = clipsToBounds
        
        mask = imageView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = bounds
    }
    
    // MARK: - Label
    
    @IBInspectable var image: UIImage? {
        didSet {
            imageView.image = image
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
