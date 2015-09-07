//
//  GraphViewController.swift
//  Calculator
//
//  Created by Kirill Daniluk on 8/22/15.
//  Copyright (c) 2015 Kirill Daniluk. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource, UIPopoverPresentationControllerDelegate {

    private struct Stats {
        static let SegueIdentifier = "Show Stats"
    }
    
    private struct StatsCalculator: Printable {
        var ymin: Double = 0
        var ymax: Double = 0
        
        mutating func calculate(y: Double) {
            if ymin > y { ymin =  y }
            if ymax < y { ymax = y }
        }
        
        var description: String {
            return "ymin = \(round(ymin))\nymax = \(round(ymax))"
        }
    }
    
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
    
    private var statistics = StatsCalculator()
    
    var program: AnyObject? {
        didSet {
            brain.program = program!
            graphView?.setNeedsDisplay()
            
        }
    }
    
    func y(#x: CGFloat) -> CGFloat? {
        brain.setVariable("M", value: Double(x))
        if let y = brain.evaluate() {
            statistics.calculate(y)
            return CGFloat(y)
        }
        else { return nil }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
                case Stats.SegueIdentifier:
                    if let svc = segue.destinationViewController as? StatsViewController {
                        if let ppc = svc.popoverPresentationController {
                            ppc.delegate = self
                        }
                        svc.text = statistics.description
                }
            default: break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!, traitCollection: UITraitCollection!) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
