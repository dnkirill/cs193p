//
//  ViewController.swift
//  Calculator
//
//  Created by Kirill Daniluk on 4/18/15.
//  Copyright (c) 2015 Kirill Daniluk. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var inputHistory: UILabel!
    
    var userIsInTheMiddleOfTyping: Bool = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "." && userIsInTheMiddleOfTyping && display.text!.rangeOfString(".") != nil { return }
        if userIsInTheMiddleOfTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func appendVariable(sender: UIButton) {
        if userIsInTheMiddleOfTyping { enter() }
        let result = brain.pushOperand("M")
        display.text = "M"
        inputHistory.text = brain.description
    }
    
    @IBAction func setMemoValue() {
        brain.variableValues["M"] = displayValue
        userIsInTheMiddleOfTyping = false
        if let result = brain.evaluate() {
            displayValue = result
        }
    }
    
    
    @IBAction func removeDigit() {
        if count(display.text!) > 1 {
            display.text = dropLast(display.text!)
        } else {
            display.text = "0"
            userIsInTheMiddleOfTyping = false
        }
        
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTyping  {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
                inputHistory.text! = brain.description + "="
            } else {
                displayValue = nil
            }
        }
    }
    
    @IBAction func getConstant(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            enter()
        }
        let constant = sender.currentTitle!
        switch constant {
            case "pi": displayValue = brain.constants["PI"]
            case "e": displayValue = brain.constants["E"]
            default: break
        }
        enter()
    }

    @IBAction func clear() {
        displayValue = nil
        brain.clearVariables()
        userIsInTheMiddleOfTyping = false
        brain.clearStack()
        inputHistory.text! = ""
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTyping = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = nil
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let nc = destination as? UINavigationController {
            destination = nc.visibleViewController
        }
        if let gvc = destination as? GraphViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "portrait plot", "landscape plot":
                    gvc.program = brain.program
                    gvc.title = brain.description
                default: break
                }
            }
        }
    }
    
    var displayValue: Double? {
        get {
            if let number = NSNumberFormatter().numberFromString(display.text!) {
                return number.doubleValue
            } else if let variable = brain.variableValues[display.text!] {
                return variable
            } else if let const = brain.constants[display.text!] {
                return const
            } else {
                return 0.0
            }
        }
        set {
            if let value = newValue {
                switch value {
                case brain.constants["PI"]!: display.text = "PI"
                case brain.constants["E"]!: display.text = "E"
                default: display.text = "\(newValue!)"
                }
            } else {
                display.text = "0"
            }
            inputHistory.text! = brain.description
            userIsInTheMiddleOfTyping = false
        }
    }
}

