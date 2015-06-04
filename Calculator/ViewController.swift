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

    ////// is being appened PI /////
    // Add numbers / digits / constants
    // Before: appendDigit
    @IBAction func appendOperand(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            switch digit {
            case ".":
                if (display.text!.rangeOfString(".") == nil) {
                    display.text = display.text! + digit
                }
            default:
                display.text = display.text! + digit
            }
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
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
}
