//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Dong, Vincent on 9/1/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import Foundation
import Darwin

struct CalculatorBrain {
    
    //Step 5: for the result need an internal var for the result
    private var accumulator: Double?
    
    //Step 17
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equals
        case random(()->Double)
    }
    
    //Step 14: try to make brain extensible
    //using table look up something like this;
    // ["π": Double.pi, "e", M_E]
    private var operations: Dictionary<String, Operation> = [
        "π": .constant(Double.pi),
        "e": .constant(M_E),
        //Step 16: Now want to add things like "sqrt": sqrt to the table, but type does not match of course
        //So add an internal data structure to support this in Step 17
        "√": .unary(sqrt),
        "cos": .unary(cos),
        //Step 18: Now some binary operations
        "*": .binary { $0 * $1 },
        "+": .binary { $0 + $1 },
        "-": .binary { $0 - $1 },
        "/": .binary { $0 / $1 },
        "=": .equals,
        //assignment 1-3: add more operations to a dozen
        "%": .unary { $0 / 100 },
        "x!": .unary { Double((1...Int($0)).reduce(1, { x, y in x * y })) }, //TODO: need handle error case (double input)
        "1/x": .unary { 1 / $0 },
        "ln": .unary(log),
        // assignment 1 extra 3:
        // Make one of your operation buttons be
        // "generate a random double-precision floating point number between 0 and 1"
        // notice the conversion to Double for both!!
        "rand": .random { Double(arc4random()) / Double(UInt32.max) },
    ]
 
    //Step 1. Think of public API first, it needs a performOperation func
//    mutating func performOperation(_ symbol: String) {
//        //Step 13 reimplement as below
////        switch symbol {
////        case "π":
////            accumulator = Double.pi
////        case "sqrt":
////            if let operand = accumulator {
////                accumulator = sqrt(operand)
////            }
////        default:
////            break
////        }
//        //Step 15 use the operation table
//        if let operation = operations[symbol] {
////            accumulator = constant
//            switch operation {
//            case .constant(let value):
//                accumulator = value
//                if pendingBinaryOperation != nil { //constant used as a second operand to a binary operation
//                    description.append(" \(symbol)")
//                    pendingBinaryOperation!.secondOperandIsDetermined = true
//                } else {
//                    description = symbol
//                }
//            case .unary(let fun):
//                if accumulator != nil {
//                    if pendingBinaryOperation != nil {
//                        description.append(" \(symbol)(\(accumulator!))")
//                        pendingBinaryOperation?.secondOperandIsDetermined = true
//                    } else {
//                        if description.isEmpty {
//                            description = "\(symbol)\(accumulator!)"
//                        } else {
//                            description = "\(symbol)(\(description))"
//                        }
//                    }
//                    accumulator = fun(accumulator!)
//                }
//            //Step 21
//            case .binary(let fun):
//                if accumulator != nil {
//                    pendingBinaryOperation = PendingBinaryOperation(function: fun,
//                                                                    firstOperand: accumulator!,
//                                                                    secondOperandIsDetermined: false)
//                    accumulator = nil
//                    if description.isEmpty {
//                        description.append("\(pendingBinaryOperation!.firstOperand) \(symbol)")
//                    } else {
//                        description.append(" \(symbol)")
//                    }
//                }
//            //Step 22
//            case .equals:
//                performPendingOperation()
//            case .random(let computation):
//                accumulator = computation()
//                if pendingBinaryOperation != nil { //constant used as a second operand to a binary operation
//                    description.append(" \(symbol)")
//                    pendingBinaryOperation!.secondOperandIsDetermined = true
//                } else {
//                    description = symbol
//                }
//            }
//
//        }
//    }
    
    // assignment 1-5
    // Add a Bool property to your CalculatorBrain called resultIsPending
    // which returns whether there is a binary operation pending.
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    // assignment 1-6
    // Add a String property to your CalculatorBrain called description
    // which returns a description of the sequence of operands and operations
    // that led to the value returned by result (or the result so far if resultIsPending).
    // The character = (the equals sign) should never appear in this description, nor should ... (ellipses).
    var description: String = ""
    //debugging
//    {
//        willSet {
//            print(newValue)
//        }
//    }
    
    //Step 22
    private mutating func performPendingOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            if !pendingBinaryOperation!.secondOperandIsDetermined {
                description.append(" \(accumulator!)")
                pendingBinaryOperation!.secondOperandIsDetermined = true
            }
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    //Step 20: a var for pending binary operation (notice optional)
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    //Step 19. Now we need some internal data structure to hold the pending binary operation
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        var secondOperandIsDetermined: Bool = false
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    //Step 2. To perform operation, it needs some operands. So a method to set operands
    mutating func setOperand(_ operand: Double) {
        //Step 6. setting operand is just to set the accumulator to the operand
        accumulator = operand
    }
    
    //Step 3. Need a way to get result. Could use a func getResult, but that's not very swifty
    var result: Double? {
        //Step 4. Now we do read only
        get {
            //Step 7. now return the value of the accumulator as the result
            //cannot use the ! here because accumulator can be nil from time to time (eg, 5 x 3 =, when x is pressed)
            //so set result to Double?
            return accumulator
        }
    }
    
    mutating func clear() {
        pendingBinaryOperation = nil
        accumulator = nil
        description = ""
    }
    
    // assignment 2-3
    // Add the capability to your CalculatorBrain to allow the input of variables.
    private var variable: String?

    mutating func setOperand(variable named: String) {
        variable = named
    }
    
    // assignment 2-4
    // add a method to evaluate the CalculatorBrain
    // (i.e. calculate its result) by substituting values for those variables
    // found in a supplied Dictionary
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool, description: String) {
            var result: Double?
            var isPending = false
            var description = ""
            
            if let node = operationTree {
                switch node.token {
                case .double(let value):
                    result = value
                    if pendingBinaryOperation != nil {
                        description += String(value)
                    }
                    
                default:
                    break
                }
                
            }
            
            return (result, isPending, description)
    }
    
    private var pendingNode: SyntaxNode?
    
    private enum Token {
        case double(Double)
        case variable
        case operation(Operation)
    }
    
    private var operationTree: SyntaxNode?
    
    private struct SyntaxNode {
        var token: Token
        var symbol: String
        var operands: [SyntaxNode]
        
        func evaluate() -> Double {
            return 0.0
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                break
            case .unary(let function):
                break
            default:
                break
            }
        }
    }
}
