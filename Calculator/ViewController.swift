//
//  ViewController.swift
//  Calculator
//
//  Created by Sangeeta van Beemen on 31/03/15 W14.
//  Copyright (c) 2015 Sangeeta van Beemen. All rights reserved.
//
//  Project 1 Native App Studio


import UIKit

class ViewController: UIViewController
{
    // display input and result
    @IBOutlet weak var display: UILabel!
    // display history of input
    @IBOutlet weak var historyLabel: UILabel!
    
    // bool so only calculate when user is done input
    var userIsInTheMiddleOfTypingNumber = false
    
    // add digit input and decimal to displays
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!
        if digit == "." && display.text!.rangeOfString(".") != nil
        {
            return
        }

        if userIsInTheMiddleOfTypingNumber
        {
            display.text = display.text! + digit
        }
        else
        {
            display.text = digit
            userIsInTheMiddleOfTypingNumber = true
        }
        
        appendToHistoryLabel(digit + " ")

    }
    
    // function to calculate with input user
    @IBAction func operate(sender: UIButton)
    {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingNumber
        {
            enter()
        }
        switch operation
        {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "cos": performOperation { cos($0) }
        case "sin": performOperation { sin($0) }
        case "π": performOperation { $0 * M_PI }
        default: break
        }
        
        appendToHistoryLabel(operation + " ")
    }
    
    // convert input string to input for operate function
    func performOperation(operation: (Double, Double) -> Double)
    {
        if operandStack.count >= 2
        {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    // convert input string to input for operate function
    func performOperation(operation: Double -> Double)
    {
        if operandStack.count >= 1
        {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    // add digit and operation of user input to history display
    func appendToHistoryLabel(text: String)
    {
        historyLabel.text = historyLabel.text! + text;
    }
    
    var operandStack = Array<Double>()
    
    // enter button stores input value
    @IBAction func enter()
    {
        userIsInTheMiddleOfTypingNumber = false
        operandStack.append(displayValue)
    }
    
    // c button clears memory and displays
    @IBAction func clearDisplay(sender: UIButton)
    {
        operandStack.removeAll()
        display.text = ""
        historyLabel.text = ""
    }
    
    // gets value of input, sets to double and displays
    var displayValue: Double
    {
        get
        {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set
        {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingNumber = false
        }
    }

}


