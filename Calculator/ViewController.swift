//
//  ViewController.swift
//  Calculator
//
//  Created by Aaron Levin on 1/7/16.
//  Copyright © 2016 Aaron Levin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false

    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(userIsInTheMiddleOfTypingANumber) {
            if (!display.text!.containsString(".") || digit.compare(".").rawValue != 0) {
                display.text = display.text! + digit
            }
        } else{
            userIsInTheMiddleOfTypingANumber = true
            
            if (digit.compare(".").rawValue == 0) {
                display.text = "0\(digit)"
            }
            else {
                display.text = digit
            }
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if let operation = sender.currentTitle {
            if userIsInTheMiddleOfTypingANumber {
                if operation == "±"
                {
                    if display.text!.rangeOfString("-") != nil{
                        display.text = String(display.text!.characters.dropFirst())
                    }
                    else{
                        display.text! = "-" + display.text!
                    }
                    return
                }
                enter()
            }
            
            if operation == "C"
            {
                displayValue = 0
                enter()
            } else if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
    }

    
    @IBAction func deleteButton(sender: UIButton) {
        if (display.text!.characters.count < 2) {
        displayValue = 0
        userIsInTheMiddleOfTypingANumber = false
        } else if (display.text!.characters.count == 2 && display.text?.rangeOfString("-") != nil ) {
            display.text = "-0"
        } else {
            display.text = String(display.text!.characters.dropLast())
        }
        
    }
    
    
    func performOperation(operation: (Double, Double) -> Double) {
        if (operandStack.count >= 2) {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if (operandStack.count >= 1) {
            displayValue! = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    var displayValue: Double? {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            if newValue == nil {
                display.text = " "
            } else{
                display.text = (newValue == 0) ? "0" : "\(newValue!)"
            }
        }
    }
    
}

