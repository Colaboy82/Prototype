//
//  ColorUtils.swift
//  Aux Plz
//
//  Created by Shahar Ben-Dor on 11/26/18.
//  Copyright © 2018 Spectre. All rights reserved.
//

import Foundation
import UIKit

class ColorUtils {
    private static func applyBackground(bg: UIImage?) -> UIImage? {
        if let bg = bg {
            if ColorScheme.isDark {
                return applyBrightnessContrast(brightness: -0.475, contrast: 0.1, image: bg)
            } else {
                return applyBrightnessContrast(brightness: 0.25, contrast: 0.9, image: bg)
            }
        }
        
        return nil
    }
    
    private static func applyBrightnessContrast(brightness: Float?, contrast: Float?, image: UIImage) -> UIImage {
        let aCGImage = image.cgImage
        let aCIImage = CIImage(cgImage: aCGImage!)
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CIColorControls")
        filter!.setValue(aCIImage, forKey: "inputImage")
        
        if let brightness = brightness {
            filter!.setValue(brightness, forKey: "inputBrightness")
        }
        
        if let contrast = contrast {
            filter!.setValue(contrast, forKey: "inputContrast")
        }
        let outputImage = filter!.outputImage!
        let cgimg = context.createCGImage(outputImage, from: outputImage.extent)
        let newUIImage = UIImage(cgImage: cgimg!)
        return newUIImage
    }
    
    public static func apply(superView: UIView, bgImage: UIImageView? = nil, hardIgnore: [UIView]? = nil, softIgnore: [UIView]? = nil, applySections: Bool, isMain: Bool) {
        if isMain {
            superView.backgroundColor = ColorScheme.bg
        }
        
        var newSoft = softIgnore
        if let bg = bgImage {
            bg.image = applyBackground(bg: bg.image)
            
            if newSoft == nil {
                newSoft = [UIView]()
            }
            
            if !newSoft!.contains(bg) {
                newSoft!.append(bg)
            }
        }
        
        for view in superView.subviews {
            if view.tag == -2 || (hardIgnore != nil && hardIgnore!.contains(view)) {
                continue
            }
            
            if view.tag == -1 || (softIgnore != nil && softIgnore!.contains(view)) {
                apply(superView: view, bgImage: nil, hardIgnore: hardIgnore, softIgnore: softIgnore, applySections: applySections, isMain: false)
                continue
            }
            
            if let field = view as? UITextField {
                field.minimumFontSize = (field.font?.pointSize ?? 7) - 3
                if field.layer.borderWidth > 0 {
                    updateOutline(textField: field, state: .regular)
                }
                
                if let fieldX = field as? UITextFieldX {
                    fieldX.updateLook()
                    continue
                }
                
                field.tintColor = ColorScheme.secondary
                field.textColor = ColorScheme.text
                continue
            }
            
            if let button = view as? UIButton {
                if let buttonX = button as? UIButtonX {
                    buttonX.updateLook()
                } else {
                    if button.backgroundColor != nil {
                        button.backgroundColor = ColorScheme.interactive
                    } else {
                        button.tintColor = ColorScheme.primary
                        button.setTitleColor(ColorScheme.primary, for: .normal)
                    }
                }
                
                continue
            }
            
            if let gradientLabel = view as? UIGradientLabel {
                gradientLabel.backgroundColor = UIColor.clear
                gradientLabel.labelFontSize = (UIScreen.main.bounds.width / 320) * gradientLabel.defaultLabelFontSize
                //gradientLabel.labelFontName = "AvenirNext-Regular"
                gradientLabel.gradientFirstColor = ColorScheme.gradient1
                gradientLabel.gradientSecondColor = ColorScheme.gradient2
                gradientLabel.gradientStart = CGPoint(x: 0, y: 0)
                gradientLabel.gradientEnd = CGPoint(x: 1, y: 1)
                
                gradientLabel.label.setLineSpacing(lineSpacing: 1, lineHeightMultiple: 0.85)
                
                if !superView.isKind(of: UIShadowView.self) && gradientLabel.shadowOpacity > 0 {
                    let shadowView = UIShadowView(frame: gradientLabel.frame)
                    let constraints = gradientLabel.constraints
                    gradientLabel.removeConstraints(constraints)
                    gradientLabel.frame = shadowView.bounds
                    superView.addSubview(shadowView)
                    shadowView.addSubview(gradientLabel)
                    shadowView.addConstraints(constraints)
                    shadowView.updateConstraints()
                    
                    shadowView.shadowColor = gradientLabel.shadowColor
                    shadowView.shadowRadius = gradientLabel.shadowRadius
                    shadowView.shadowOffset = gradientLabel.shadowOffset
                    shadowView.shadowOpacity = ColorScheme.isDark ? gradientLabel.shadowOpacity + 0.25 : gradientLabel.shadowOpacity
                }
                
                continue
            }
            
            if let gradientImage = view as? UIGradientImage {
                gradientImage.backgroundColor = UIColor.clear
                gradientImage.contentMode = .scaleAspectFit
                gradientImage.gradientFirstColor = ColorScheme.gradient1
                gradientImage.gradientSecondColor = ColorScheme.gradient2
                
                if !superView.isKind(of: UIShadowView.self) && gradientImage.shadowOpacity > 0 {
                    let shadowView = UIShadowView(frame: gradientImage.frame)
                    let constraints = gradientImage.constraints
                    gradientImage.removeConstraints(constraints)
                    gradientImage.frame = shadowView.bounds
                    superView.addSubview(shadowView)
                    shadowView.addSubview(gradientImage)
                    shadowView.addConstraints(constraints)
                    shadowView.updateConstraints()
                    shadowView.layoutIfNeeded()
                    
                    shadowView.shadowColor = gradientImage.shadowColor
                    shadowView.shadowRadius = gradientImage.shadowRadius
                    shadowView.shadowOffset = gradientImage.shadowOffset
                    shadowView.shadowOpacity = ColorScheme.isDark ? gradientImage.shadowOpacity + 0.25 : gradientImage.shadowOpacity
                }
                
                continue
            }
            
            if let label = view as? UILabel {
                if let labelX = label as? UILabelX {
                    labelX.updateLook()
                    continue
                }
                
                label.textColor = ColorScheme.reducedHighContrast
                continue
            }
            
            view.tintColor = ColorScheme.primary
            
            if view.isKind(of: UIVisualEffectView.self) || superView.isKind(of: UIVisualEffectView.self) {
                apply(superView: view, bgImage: nil, hardIgnore: hardIgnore, softIgnore: softIgnore, applySections: applySections, isMain: false)
                continue
            }
            
            if let view = view as? UIViewX, !view.ignoresColorScheme {
                if view.gradientFirstColor != UIColor.clear && view.gradientSecondColor != UIColor.clear {
                    view.gradientFirstColor = ColorScheme.gradient1
                    view.gradientSecondColor = ColorScheme.gradient2
                }
                
                view.borderColor = ColorScheme.primary
            } else if let image = view as? UIImageViewX {
                image.updateLook()
            } else if view.isKind(of: UITableView.self) && view.backgroundColor != nil && view.backgroundColor!.rgba.alpha > 0 {
                view.backgroundColor = ColorScheme.bg
            } else if view.subviews.count == 0 && view.backgroundColor != nil && view.backgroundColor!.rgba.alpha > 0 {
                view.backgroundColor = ColorScheme.highContrast
            } else if applySections && view.backgroundColor != nil && view.backgroundColor!.rgba.alpha > 0 && view.subviews.count >= 1 {
                view.backgroundColor = ColorScheme.lowContrast
            }
            
            if view.tag != -3 {
                apply(superView: view, bgImage: nil, hardIgnore: hardIgnore, softIgnore: softIgnore, applySections: applySections, isMain: false)
            }
        }
    }
    
    enum TextFieldState {
        case regular
        case success
        case error
    }
    
    public static func updateOutline(textField: UITextField, state: TextFieldState) {
        if state == .regular {
            textField.layer.borderColor = ColorScheme.reducedHighContrast.withAlphaComponent(0.7).cgColor
        } else if state == .success {
            textField.layer.borderColor = ColorScheme.success.cgColor
        } else {
            textField.layer.borderColor = ColorScheme.error.cgColor
        }
    }
}
