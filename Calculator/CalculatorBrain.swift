//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Kirill Daniluk on 4/26/15.
//  Copyright (c) 2015 Kirill Daniluk. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: Printable {
        case Operand(Double)
        case Variable(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Variable(let symbol):
                    return "\(symbol)"
                case .UnaryOperation(let symbol, _):
                    return "\(symbol)"
                case .BinaryOperation(let symbol, _):
                    return "\(symbol)"
                }
            }
        }
    }
    
    let constants = ["PI": Double(round(M_PI * 100) / 100),
                     "E": Double(round(M_E * 100) / 100)]
    
    var variableValues = [String: Double]()
    
    var description: String {
        get {
            var (result, remainder) = getOpsForDescription(opStack)
            var resultList = [String]()
            resultList.append(result!)
            while !remainder.isEmpty {
                (result, remainder) = getOpsForDescription(remainder)
                resultList.insert(result!, atIndex: 0)
            }
            if !resultList.isEmpty {
                return ",".join(resultList)
            } else { return "" }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String: Op]()
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return opStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbol in opSymbols {
                    if let op = knownOps[opSymbol] {
                        newOpStack.append(op)
                    } else if opSymbol == "M" {
                        newOpStack.append(.Variable(opSymbol))
                    } else if (opSymbol as NSString).doubleValue != 0 {
                        var operand = (opSymbol as NSString).doubleValue
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
        
    }
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
    }
    
    func clearStack() {
        opStack = [Op]()
        println("\(opStack) is Empty")
    }
    
    func clearVariables() {
        variableValues = [String: Double]()
        println("Variables: \(variableValues)")
    }
    
    func setVariable(symbol: String, value: Double) {
        variableValues[symbol] = value
    }

    private func getOpsForDescription(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .Variable(let variable):
                return (variable, remainingOps)
            case .UnaryOperation(let symbol, _):
                let operandEvaluation = getOpsForDescription(remainingOps)
                if let operand = operandEvaluation.result {
                    return ("\(symbol + operand)", operandEvaluation.remainingOps)
                }
            case .BinaryOperation(let symbol, _):
                let op1Evaluation = getOpsForDescription(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = getOpsForDescription(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return ("(\(operand2 + symbol + operand1))", op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return ("?", ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
//        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }

    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Variable(let symbol):
                if let value = variableValues[symbol] {
                    println("Eval a variable \(symbol) = \(value)")
                    return (value, remainingOps)
                } else { return (nil, ops) }
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}