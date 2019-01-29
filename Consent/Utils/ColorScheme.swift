//
//  Color Scheme.swift
//  UIExperiments
//
//  Created by Shahar Ben-Dor on 8/16/18.
//  Copyright © 2018 Quantum. All rights reserved.
//

import Foundation
import UIKit

class ColorScheme {
    /*
     CREDITS:
     - Key: Key Password by Arunkumar from the Noun Project
     - Email: Email by Alfa Design from the Noun Project
     - Person: person by mikicon from the Noun Project
     - Phone: Phone by NOVITA ASTRI from the Noun Project
     - Name: name by Adrien Coquet from the Noun Project
     - Redo: redo by P.J. Onori from the Noun Project
     - Radio: Radio by Michiel Willemsen from the Noun Project
     - QR: qr by Danil Polshin from the Noun Project
     - Num Pad: Pin by Yasir B. Eryılmaz from the Noun Project
     - Upvote Arrow: up arrow by ArtWorkLeaf from the Noun Project
                     down arrow by ArtWorkLeaf from the Noun Project
     - Flash: Flash by Bakunetsu Kaito from the Noun Project
              No Flash by Bakunetsu Kaito from the Noun Project
     - Pin: Pin by Gregor Cresnar from the Noun Project
     - Like Buttons: like by Sophia Bai from the Noun Project
                     liked by Sophia Bai from the Noun Project
                     Dislike by Sophia Bai from the Noun Project
                     disliked by Sophia Bai from the Noun Project
     - Notification: notification by Amazing from the Noun Project
     - Airplay: broadcast by Jamison Wieser from the Noun Project
     */
    
    static var isDark = false
    static let shadowScalar: Float = 2.5
    static let activityAnimationNamed: String = "Loading Animation"
    
    static let primary = #colorLiteral(red: 0.368627451, green: 0.6117647059, blue: 0.662745098, alpha: 1)
    static let secondary = #colorLiteral(red: 0.6274509804, green: 0.631372549, blue: 0.6470588235, alpha: 1)
    static let gradient1 = #colorLiteral(red: 0.2784313725, green: 0.537254902, blue: 0.9294117647, alpha: 1)
    static let gradient2 = #colorLiteral(red: 0.4470588235, green: 0.8235294118, blue: 1, alpha: 1)
    
    static let interactive = #colorLiteral(red: 0.368627451, green: 0.6117647059, blue: 0.662745098, alpha: 1)
    static let interactiveD1 = #colorLiteral(red: 0.3074070139, green: 0.1102655593, blue: 0.5513277967, alpha: 1)
    static let interactiveGradient1 = #colorLiteral(red: 0.8078431373, green: 0.6156862745, blue: 0.9882352941, alpha: 1)
    static let interactiveGradient2 = #colorLiteral(red: 0.2235294118, green: 0.05490196078, blue: 0.6823529412, alpha: 1)
    
    static let l1 = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let l2 = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
    static let l3 = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
    static let d1 = #colorLiteral(red: 0.2352941176, green: 0.2352941176, blue: 0.2352941176, alpha: 1)
    static let d2 = #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
    static let d3 = #colorLiteral(red: 0.3137254902, green: 0.3137254902, blue: 0.3137254902, alpha: 1)
    static let d4 = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
    
    static let error = #colorLiteral(red: 1, green: 0.3529411765, blue: 0.3529411765, alpha: 1)
    static let success = #colorLiteral(red: 0.3921568627, green: 0.9019607843, blue: 0.7058823529, alpha: 1)
    static let warning = #colorLiteral(red: 1, green: 0.6941337585, blue: 0, alpha: 1)
    
    static var lowContrast: UIColor {
        get {
            if isDark {
                return d3
            }
            
            return l2
        }
    }
    static var increasedlowContrast: UIColor {
        get {
            if isDark {
                return d4
            }
            
            return l3
        }
    }
    static var highContrast: UIColor {
        get {
            if isDark {
                return l1
            }

            return d1
        }
    }
    static var reducedHighContrast: UIColor {
        get {
            if isDark {
                return l2
            }

            return d3
        }
    }
    
//    static let error = UIColor(red: 255/255, green: 90/255, blue: 90/255, alpha: 1)
//    static let success = UIColor(red: 100/255, green: 230/255, blue: 180/255, alpha: 1)
    static var disabled: UIColor {
        get {
            if isDark {
                return d4
            }

            return l3
        }
    }
    
    static let disabledTint: UIColor = ColorScheme.darkText
    static let darkText = l1
    static let lightText = d2
    static var text: UIColor {
        get {
            if isDark {
                return darkText
            }
            
            return lightText
        }
    }
    static var bg: UIColor {
        get {
            if isDark {
                return d1
            }
            
            return l1
        }
    }
    static let darkTint = bg
    
    static let titleFont = UIFont(name: "AvenirNext-Medium", size: 35)
}
