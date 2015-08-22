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
        axesDrawer.drawAxesInRect(bounds, origin: graphCenter, pointsPerUnit: scale)
    }
    
}
