//
//  ViewController.swift
//  Calculator
//
//  Created by Kirill Daniluk on 4/18/15.
//  Copyright (c) 2015 Kirill Daniluk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
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
        let constant = sender.currentTitle!
        switch constant {
            case "pi": displayValue = M_PI
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
    
    var displayValue: Double? {
        get {
            if let number = NSNumberFormatter().numberFromString(display.text!) {
                return number.doubleValue
            } else if let variable = brain.variableValues[display.text!] {
                return variable
            } else {
                return 0.0
            }
        }
        set {
            if let value = newValue {
                display.text = "\(newValue!)"
            } else {
                display.text = "0"
            }
            inputHistory.text! = brain.description
            userIsInTheMiddleOfTyping = false
        }
    }
}

