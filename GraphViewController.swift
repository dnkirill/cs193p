//
//  GraphViewController.swift
//  Calculator
//
//  Created by Kirill Daniluk on 8/22/15.
//  Copyright (c) 2015 Kirill Daniluk. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {

    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "scale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "moveOrigin:"))
            let taps = UITapGestureRecognizer(target: graphView, action: "setOrigin:")
            taps.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(taps)
        }
    }
    
    private var brain = CalculatorBrain()
    
    var program: AnyObject? {
        didSet {
            brain.program = program!
            graphView?.setNeedsDisplay()
            
        }
    }
    
    func y(#x: CGFloat) -> CGFloat? {
        brain.setVariable("M", value: Double(x))
        if let y = brain.evaluate() {
            return CGFloat(y)
        }
        else { return nil }
    }
}
