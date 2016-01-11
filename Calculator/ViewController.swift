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
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        print(operation)
        switch operation {
        case "✕": performOperation {$0 * $1}
        case "÷": performOperation {$1 / $0}
        case "+": performOperation {$0 + $1}
        case "−": performOperation {$1 - $0}
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "C":
            operandStack.removeAll()
            displayValue = 0
        default: break
        }
    }
    @IBAction func piButton(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        displayValue = M_PI
        enter()
    }
    
    @IBAction func deleteButton(sender: UIButton) {
        if (display.text!.characters.count > 1) {
            display.text = String(display.text!.characters.dropLast())
        } else {
            displayValue = 0
            userIsInTheMiddleOfTypingANumber = false
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
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("op stack = \(operandStack)")
    }
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = (newValue == 0) ? "0" : "\(newValue)"
            
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
}

