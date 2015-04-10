//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Sangeeta van Beemen on 09/04/15 W15.
//  Copyright (c) 2015 Sangeeta van Beemen. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    // determine return value for a operation
    private enum Op: Printable
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case ConstantOperation(String, () -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Variable(String)
    
        var description: String
        {
            get
            {
                switch self
                {
                    case .Operand(let operand):
                        return "\(operand)"
                    case .UnaryOperation(let symbol, _):
                        return symbol
                    case .ConstantOperation(let symbol, _):
                        return symbol
                    case .BinaryOperation(let symbol, _):
                        return symbol
                    case .Variable(let symbol):
                        return symbol
                }
            }
        }
    }

    // the stack to store input user
    private var opStack = [Op]()
    
    // empty dict with string as key and Op as value
    private var knownOps = [String:Op]()
    
    // dictionary to store unknown variables
    var variableValues = [String: Double]()
    
    //init the dictionary and the values/ functions of the operations
    init()
    {
        func learnOp (op: Op)
        {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷", { $1 / $0 }))
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−", { $1 - $0 }))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.ConstantOperation("π", { M_PI }))
    }

    // read input of oparation buttons
    var description: String
    {
        get
        {
            var (result, ops) = ("", opStack)
            do
            {
                var current: String?
                (current, ops) = description(ops)
                result = result == "" ? current! : "\(current!), \(result)"
            }
            while ops.count > 0
            return result
        }
    }
    
    // display calcuations for pretty printing
    private func description(ops: [Op]) -> (result: String?, remainingOps: [Op])
    {
        if !ops.isEmpty
        {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op
            {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .ConstantOperation(let symbol, _):
                return (symbol, remainingOps);
            case .UnaryOperation(let symbol, _):
                let operandEvaluation = description(remainingOps)
                if let operand = operandEvaluation.result
                {
                    return ("\(symbol)(\(operand))", operandEvaluation.remainingOps)
                }
            case .BinaryOperation(let symbol, _):
                let op1Evaluation = description(remainingOps)
                if var operand1 = op1Evaluation.result
                {
                    if remainingOps.count - op1Evaluation.remainingOps.count > 2
                    {
                        operand1 = "(\(operand1))"
                    }
                    let op2Evaluation = description(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result
                    {
                        return ("\(operand2) \(symbol) \(operand1)", op2Evaluation.remainingOps)
                    }
                }
            case .Variable(let symbol):
                return (symbol, remainingOps)
            }
        }
        return ("?", ops)
    }
    
    // a recursive function to evaluate the stack
    // takes the stack, returns a tuple with the result and the remaing stack
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty
        {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op
            {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .ConstantOperation(_, let operation):
                return (operation(), remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvauation = evaluate(remainingOps)
                if let operand = operandEvauation.result
                {
                    return (operation(operand), operandEvauation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result
                {
                    // recurse again to get the next op
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result
                    {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Variable(let symbol):
                return (variableValues[symbol], remainingOps)
            }
        }
        return (nil, ops)
    }
    
    // functions that evealutes the operands and operations
    func evaluate() -> Double?
    {
        let (result, remainder) = evaluate(opStack)
            return result
    }

    func pushOperand(operand: Double) -> Double?
    {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    // pushes symbol of operation and varibale to stack
    func pushOperand(symbol: String) -> Double?
    {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    // looks up variable symbool in dictionary  
    func performOperation(symbol: String) -> Double?
    {
        if let operation = knownOps[symbol]
        {
            opStack.append(operation)
        }
        return evaluate()
    }
}
