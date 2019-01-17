//
//  ViewUtils.swift
//  UIExperiments
//
//  Created by Shahar Ben-Dor on 8/18/18.
//  Copyright © 2018 Quantum. All rights reserved.
//

import Foundation
import UIKit

class ViewUtils {
    enum Edge {
        case Left
        case Right
        case Top
        case Bottom
    }
    
    static func convertPoint(point: CGPoint, fromView: UIView, toView: UIView) -> CGPoint {
        var x = point.x + fromView.frame.origin.x
        var y = point.y + fromView.frame.origin.y
        var sView1 = fromView
        while let sView = sView1.superview {
            x += sView.frame.origin.x
            y += sView.frame.origin.y
            sView1 = sView
        }
        
        var sView2 = toView
        while let sView = sView2.superview {
            sView2 = sView
            x -= sView.frame.origin.x
            y -= sView.frame.origin.y
        }
        
        return CGPoint(x: x, y: y)
    }
    
    static func distance(view1: UIView, edge1: Edge, view2: UIView?, edge2: Edge, parent: UIView) -> CGFloat {
        let pt1 = view1.convert(view1.bounds.origin, to: parent)
        //let pt1 = convertPoint(point: view1.bounds.origin, fromView: view1, toView: parent)
        var edgePt1: CGFloat
        switch edge1 {
        case .Bottom:
            edgePt1 = pt1.y + view1.frame.height
        case .Top:
            edgePt1 = pt1.y
        case .Right:
            edgePt1 = pt1.x + view1.frame.width
        case .Left:
            edgePt1 = pt1.x
        }
        
        var to: UIView
        view2 == nil ? (to = parent) : (to = view2!)
        let pt2 = to.convert(to.bounds.origin, to: parent)
        //let pt2 = convertPoint(point: to.bounds.origin, fromView: to, toView: parent)
        var edgePt2: CGFloat
        switch edge2 {
        case .Bottom:
            edgePt2 = pt2.y + to.frame.height
        case .Top:
            edgePt2 = pt2.y
        case .Right:
            edgePt2 = pt2.x + to.frame.width
        case .Left:
            edgePt2 = pt2.x
        }
        
        return CGFloat(abs(edgePt2 - edgePt1))
    }
}
