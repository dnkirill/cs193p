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
    
    var operandStack = [Double]()
    
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
    
    @IBAction func removeDigit() {
        if count(display.text!) > 1 {
            display.text = dropLast(display.text!)
        } else {
            display.text = "0"
            userIsInTheMiddleOfTyping = false
        }
        
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTyping  {
            enter()
        }
        inputHistory.text! += "\(operation) "
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $1 + $0 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        default: break
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
    private func performOperation(operation: Double -> Double?) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double?) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    @IBAction func clear() {
        display.text = "0"
        userIsInTheMiddleOfTyping = false
        operandStack = [Double]()
        inputHistory.text! = ""
    }
    
    @IBAction func enter() {
        if userIsInTheMiddleOfTyping {
            inputHistory.text! += "\(displayValue!) "
        }
        userIsInTheMiddleOfTyping = false
        operandStack.append(displayValue!)
        println("operandStack = \(operandStack)")
    }
    
    var displayValue: Double? {
        get {
            if let number = NSNumberFormatter().numberFromString(display.text!) {
                return number.doubleValue
            }
            return 0.0
        }
        set {
            display.text = "\(newValue!)"
            userIsInTheMiddleOfTyping = false
        }
    }
}

