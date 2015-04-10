//
//  ViewController.swift
//  Calculator
//
//  Created by Sangeeta van Beemen on 9/04/15 W14.
//  Copyright (c) 2015 Sangeeta van Beemen. All rights reserved.
//
//  Project 2 Native App Studio


import UIKit

class ViewController: UIViewController
{
    // display input and result
    @IBOutlet weak var display: UILabel!
    // display history of input
    @IBOutlet weak var historyLabel: UILabel!
    
    // bool so only calculate when user is done input
    var userIsInTheMiddleOfTypingNumber = false
    
    // variable for model app
    var brain = CalculatorBrain()
    
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
            historyLabel.text = brain.description != "?" ? brain.description : ""
        }

    }
    
    // function to calculate with input user
    @IBAction func operate(sender: UIButton)
    {
        if userIsInTheMiddleOfTypingNumber
        {
            enter()
        }
        if let operation = sender.currentTitle
        {
            if let result = brain.performOperation(operation)
            {
                displayValue = result
            }
            else
            {
                // error indication
                displayValue = nil
            }
        }

    }

    // call value stored in memory
    @IBAction func memorySaveButton(sender: UIButton) 
    {
        if let variable = last(sender.currentTitle!)
        {
            if displayValue != nil
            {
                brain.variableValues["\(variable)"] = displayValue
                if let result = brain.evaluate()
                {
                    displayValue = result
                }
                else
                {
                    displayValue = nil
                }
            }
        }
        userIsInTheMiddleOfTypingNumber = false
    }
    
    // ustore a value in memomry
    @IBAction func memoryUseButton(sender: UIButton)
    {
        if userIsInTheMiddleOfTypingNumber
        {
            enter()
        }
        if let result = brain.pushOperand(sender.currentTitle!)
        {
            displayValue = result
        }
        else
        {
            displayValue = nil
        }
    }    
    
    // enter button stores input value
    @IBAction func enter()
    {
        userIsInTheMiddleOfTypingNumber = false
        if displayValue != nil
        {
            if let result = brain.pushOperand(displayValue!)
            {
                displayValue = result
            }
            else
            {
                displayValue = 0
            }
        }
    }
    
    // c button clears memory and displays
    @IBAction func clearDisplay(sender: UIButton)
    {
        brain = CalculatorBrain()
        displayValue = 0
        historyLabel.text = ""
    }
    
    // gets value of input, sets to double and displays
    var displayValue: Double?
    {
        get
        {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set
        {
            if (newValue != nil)
            {
                display.text = "\(newValue!)"
            }
            else
            {
                display.text = " "
            }
            userIsInTheMiddleOfTypingNumber = false
            historyLabel.text = brain.description + " ="
        }
    }

}


