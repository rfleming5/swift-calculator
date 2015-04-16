//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Richard Fleming on 3/21/15.
//  Copyright (c) 2015 Richard Fleming. All rights reserved.
//

import Foundation

class CalculatorBrain {
    //var opStack = Array<Op>()
    //var knownOps = Dictionary<String, Ops>()
    
    private enum Op: Printable { // A protocol that this enum implements this "printable"
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol,_):
                    return symbol
                case .BinaryOperation(let symbol,_):
                    return symbol
                }
            }
        }
    }
    
    // Our operation stack
    private var opStack = [Op]()
    
    // Type dictionary
    private var knownOps = [String:Op]()
    
    // Add lists into our dictionary
    init() {
        // For the assignment we will want something like this
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }

        knownOps["×"] = Op.BinaryOperation("×") { $0 * $1 }
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["+"] = Op.BinaryOperation("+") { $0 + $1 }
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    // Clear the operation stack
    func clearStack() {
        opStack = [Op]()
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()

            // Really op.Operand
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            // If we have only one operator ie square root, grab it and the next value
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            // These are +'s, -'s, *'s, /'s
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
    
    // Convert the operation stack as a string and return it
    func getStackAsString() -> String {
        return "\(opStack)"
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
}
