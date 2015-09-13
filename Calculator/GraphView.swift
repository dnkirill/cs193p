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
    var gestureInProgress = false
    
    private var graphCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var origin: CGPoint? { didSet { setNeedsDisplay() } }
    @IBInspectable
    var scale: CGFloat = 50.0 { didSet {
        scale = ceil(scale)
        setNeedsDisplay() }
    }
    @IBInspectable
    var color: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 2.0 { didSet { setNeedsDisplay() } }
    
    struct GraphQuality {
        var goodQuality: CGFloat = 1
        var lowQuality: CGFloat = 30
    }
    
    weak var dataSource: GraphViewDataSource?
    
    var snapshot: UIView? = nil
    
    override func drawRect(rect: CGRect) {
        origin = origin ?? graphCenter
        axesDrawer.drawAxesInRect(bounds, origin: origin!, pointsPerUnit: scale)
        if !gestureInProgress {
            drawPointInRect(bounds, origin: origin!, pointsPerUnit: scale)
        } else {
            drawSimplifiedGraphInRect(bounds, origin: origin!, pointsPerUnit: scale)
        }
    }
    
    func drawPointInRect(bounds: CGRect, origin: CGPoint, pointsPerUnit: CGFloat) {
        UIColor.blueColor().set()
        var point = CGPoint()
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        var firstValue = true
            for var i = 0; i <= Int(bounds.size.width * 2); i++ {
                point.x = CGFloat(i) / 2
                let currentX = (point.x - origin.x) / scale
                let roundedX = CGFloat(round(currentX * 100)/100)
                if let y = dataSource?.y(x: roundedX){
                    if !y.isNormal && !y.isZero {
                        firstValue = true
                        continue
                    }
                    point.y = origin.y - y * scale
                    if firstValue {
                        path.moveToPoint(point)
                        firstValue = false
                    } else {
                        path.addLineToPoint(point)
                        println("Added line: x=\(point.x), y=\(point.y)")
                    }
                } else {
                    firstValue = true
                }
        }
        path.stroke()
    }
    
    func drawSimplifiedGraphInRect(bounds: CGRect, origin: CGPoint, pointsPerUnit: CGFloat) {
        for var i = 0; i <= Int(bounds.size.width * contentScaleFactor / GraphQuality().lowQuality); i++ {
            let x = CGFloat(i) / contentScaleFactor * GraphQuality().lowQuality
            if let y = dataSource?.y(x: (x - origin.x) / scale) {
                if !y.isNormal && !y.isZero {
                    continue
                }
                let y = origin.y - y * scale
                var rectForPoint = CGRect(x: x, y: y, width: 2, height: 2)
                var point = UIBezierPath(ovalInRect: rectForPoint)
                point.stroke()
            }
        }
    }
    
    func scale(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .Changed:
            if !gestureInProgress { gestureInProgress = true }
            scale *= gesture.scale
            gesture.scale = 1.0
            println("Origin X: \(origin?.x), Y: \(origin?.y) ")
        case .Ended:
            gestureInProgress = false
            setNeedsDisplay()
        default: break
        }
    }

    func moveOrigin(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Changed:
            if !gestureInProgress { gestureInProgress = true }
            let translation = gesture.translationInView(self)
            origin?.x += ceil(translation.x)
            origin?.y += ceil(translation.y)
            gesture.setTranslation(CGPointZero, inView: self)
            println("Origin X: \(origin?.x), Y: \(origin?.y) ")
        case .Ended:
            gestureInProgress = false
            setNeedsDisplay()
        default: break
        }
    }
    
    func setOrigin(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            origin = graphCenter
        }
    }
}
