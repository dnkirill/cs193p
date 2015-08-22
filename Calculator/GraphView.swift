//
//  GraphView.swift
//  Calculator
//
//  Created by Kirill Daniluk on 8/22/15.
//  Copyright (c) 2015 Kirill Daniluk. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func y(#x: CGFloat) -> CGFloat?
}

@IBDesignable
class GraphView: UIView {
   
    let axesDrawer = AxesDrawer(color: UIColor.redColor())

    private var graphCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var origin: CGPoint? { didSet { setNeedsDisplay() } }
    @IBInspectable
    var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.redColor() { didSet { setNeedsDisplay() } }
    
    override func drawRect(rect: CGRect) {
        origin = origin ?? graphCenter
        axesDrawer.drawAxesInRect(bounds, origin: origin!, pointsPerUnit: scale)
    }
    
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1.0
        }
    }
    
    func moveOrigin(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            origin?.x += translation.x
            origin?.y += translation.y
            gesture.setTranslation(CGPointZero, inView: self)
        default: break
        }
    }
    
    func setOrigin(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            origin = graphCenter
        }
    }
    
}
