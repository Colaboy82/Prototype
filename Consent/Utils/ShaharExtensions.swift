//
//  Extensions.swift
//  Q-Me Remade
//
//  Created by Shahar Ben-Dor on 9/5/18.
//  Copyright © 2018 Quantum. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

extension String {
    func trimmingTrailingSpaces() -> String {
        var t = self
        while t.hasSuffix(" ") {
            t = "" + t.dropLast()
        }
        return t
    }
    
    mutating func trimmedTrailingSpaces() {
        self = self.trimmingTrailingSpaces()
    }
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    func hasSpecialCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
    enum IphoneName {
        case i5, i8, i8plus, iXS, iXSMax, iXR, unknown
    }
    
    var iphoneName: IphoneName {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .i5
        case 1334:
            return .i8
        case 1920, 2208:
            return .i8plus
        case 2436:
            return .iXS
        case 2688:
            return .iXSMax
        case 1792:
            return .iXR
        default:
            return .unknown
        }
    }
    
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}

extension UIImage {
    public convenience init? (color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    static func load(url: URL, completion: @escaping (UIImage?) -> ()) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async() {
                completion(UIImage(data: data))
            }
        }
    }
    
    static func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
}

extension UIColor {
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage / 100, 1.0),
                           green: min(g + percentage / 100, 1.0),
                           blue: min(b + percentage / 100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
    
    func copy() -> UIColor? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: r, green: g, blue: b, alpha: a)
        }
        
        return nil
    }
    
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}

extension UIViewController: UIViewControllerTransitioningDelegate {
    @objc func applyColorScheme(applyBG: Bool) {
        ColorUtils.apply(superView: view, applySections: false, isMain: applyBG)
    }
    
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        
        if let navigation = self.presentedViewController as? UINavigationController, let visibleController = navigation.visibleViewController {
            return visibleController.topMostViewController()
        }
        
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            
            return tab.topMostViewController()
        }
        
        return self.presentedViewController!.topMostViewController()
    }
    
    @objc func setColors() {}
}

extension UIView {
    func duplicate<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
    
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
    
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
    
    func convertCenterToParent(parent: UIView) -> CGPoint {
        let view = superview ?? self
        return view.convert(center, to: parent)
    }
    
    func convertFrameToParent(parent: UIView) -> CGRect {
        return convert(bounds, to: parent)
    }
    
    func copyProperties(fromView: UIView, recursive: Bool = true) {
        contentMode = fromView.contentMode
        
        backgroundColor = fromView.backgroundColor
        tintColor = fromView.tintColor
        
        layer.cornerRadius = fromView.layer.cornerRadius
        layer.maskedCorners = fromView.layer.maskedCorners
        
        layer.borderColor = fromView.layer.borderColor
        layer.borderWidth = fromView.layer.borderWidth
        
        layer.shadowOpacity = fromView.layer.shadowOpacity
        layer.shadowRadius = fromView.layer.shadowRadius
        layer.shadowPath = fromView.layer.shadowPath
        layer.shadowColor = fromView.layer.shadowColor
        layer.shadowOffset = fromView.layer.shadowOffset
        
        clipsToBounds = fromView.clipsToBounds
        layer.masksToBounds = fromView.layer.masksToBounds
        mask = fromView.mask
        layer.mask = fromView.layer.mask
        
        alpha = fromView.alpha
        isHidden = fromView.isHidden
        if let gradientLayer = layer as? CAGradientLayer, let fromGradientLayer = fromView.layer as? CAGradientLayer {
            gradientLayer.colors = fromGradientLayer.colors
            gradientLayer.startPoint = fromGradientLayer.startPoint
            gradientLayer.endPoint = fromGradientLayer.endPoint
            gradientLayer.locations = fromGradientLayer.locations
            gradientLayer.type = fromGradientLayer.type
        }
        
        if let imgView = self as? UIImageView, let fromImgView = fromView as? UIImageView {
            imgView.tintColor = .clear
            imgView.image = fromImgView.image?.withRenderingMode(fromImgView.image?.renderingMode ?? .automatic)
            imgView.tintColor = fromImgView.tintColor
        }
        
        if let btn = self as? UIButton, let fromBtn = fromView as? UIButton {
            btn.setImage(fromBtn.image(for: fromBtn.state), for: fromBtn.state)
        }
        
        if let textField = self as? UITextField, let fromTextField = fromView as? UITextField {
            if let leftView = fromTextField.leftView {
                textField.leftView = leftView.duplicate()
                textField.leftView?.copyProperties(fromView: leftView)
            }
            
            if let rightView = fromTextField.rightView {
                textField.rightView = rightView.duplicate()
                textField.rightView?.copyProperties(fromView: rightView)
            }
            
            textField.attributedText = fromTextField.attributedText
            textField.attributedPlaceholder = fromTextField.attributedPlaceholder
        }
        
        if let lbl = self as? UILabel, let fromLbl = fromView as? UILabel {
            lbl.attributedText = fromLbl.attributedText
            lbl.textAlignment = fromLbl.textAlignment
            lbl.font = fromLbl.font
            lbl.bounds = fromLbl.bounds
        }
        
        if recursive {
            for (i, view) in subviews.enumerated() {
                if i >= fromView.subviews.count {
                    break
                }
                
                view.copyProperties(fromView: fromView.subviews[i])
            }
        }
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        
        return nil
    }
}

extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}

extension CGAffineTransform {
    init (moveTo x: CGFloat, y: CGFloat, from origin: CGPoint) {
        let dx = origin.x - x
        let dy = origin.y - y
        self.init (translationX: -1 * dx, y: -1 * dy)
    }
}

extension UITableViewCell {
    var tableView: UITableView? {
        var view = self.superview
        while (view != nil && view!.isKind(of: UITableView.self) == false) {
            view = view!.superview
        }
        
        return view as? UITableView
    }
}

extension UITableViewHeaderFooterView {
    var tableView: UITableView? {
        var view = self.superview
        while (view != nil && view!.isKind(of: UITableView.self) == false) {
            view = view!.superview
        }
        
        return view as? UITableView
    }
}

extension UITableView {
    func reloadData(with animation: UITableView.RowAnimation) {
        reloadSections(IndexSet(integersIn: 0..<numberOfSections), with: animation)
    }
}

extension MPMediaItem {
    var songInfo: String {
        get {
            var toReturn = artist ?? ""
            if toReturn != "" {
                toReturn +=  " • "
            }
            
            toReturn += albumTitle ?? ""
            if toReturn == "" {
                toReturn = "---"
            }
            
            return toReturn
        }
    }
}

extension TimeInterval {
    func toString(hoursAllowed: Bool = true, millisAllowed: Bool = false) -> String {
        
        let time = NSInteger(self)
        
        let ms = millisAllowed ? Int((self.truncatingRemainder(dividingBy: 1)) * 1000) : 0
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        var string = ""
        if hours > 0 && hoursAllowed {
            string += "\(hours):"
        }
        
        if minutes > 0 {
            string += "\(minutes):"
        } else {
            string += "0:"
        }
        
        if seconds > 0 {
            string += String(format: "%0.2d", seconds)
        } else {
            string += "00"
        }
        
        if millisAllowed && ms > 0 {
            string += ":" + String(format: "%0.3d", ms)
        }
        
        return string
    }
}
