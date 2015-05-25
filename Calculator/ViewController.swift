//
//  ViewController.swift
//  Calculator
//
//  Created by Richard Fleming on 3/18/15.
//  Copyright (c) 2015 Richard Fleming. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var displayOperationStack: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    
    // For our function operations
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
    
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        
    }
    
    // Clears out if the user is typing
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false

        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    // Clear the calculator of the contents
    @IBAction func clear(sender: UIButton) {
        brain.clearStack()
        displayValue = 0;
    }

    // Add numbers / digits
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    // Adding a decimal point
    @IBAction func appendPeriod(sender: UIButton) {
        // Grab the numeric field
        let digit = sender.currentTitle!
        
        // If we have a period we want to append it
        if userIsInTheMiddleOfTypingANumber {
            if(display.text!.rangeOfString(".") == nil) {
                display.text = display.text! + digit
            }
        }
    }

    // convert the string to a double / return the string value
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            displayOperationStack.text = brain.getStackAsString()
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    

    /*
        switch operation {
        case "×": performOperation({ (op1, op2) in return op1 * op2 })
            case "÷": performOperation({ (op1, op2) in return op2 / op1 })
            case "+": performOperation({ (op1, op2) in return op1 + op2 })
            case "−": performOperation({ (op1, op2) in return op2 - op1 })
            case "√": performOperation({ (op1) in sqrt(op1) })
            default: break
        }
    }
    */

    /*
    // Verifies if the operation stack is valid
    // Takes a function, returns that value and then clears the screen
    func performOperation(operation: (Double) -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }

    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    */
}
