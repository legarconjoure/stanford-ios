//
//  ViewController.swift
//  Calculator
//
//  Created by Dong, Vincent on 8/31/17.
//  Copyright © 2017 Dong, Vincent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var userIsInTheMiddleOfTyping = false
    
    // L06 Demo memory cycle breaking
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.addUnaryOperation(named: "✅")  { [weak self] in
            self?.display.textColor = UIColor.green
            return sqrt($0)
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
//        print(sender.currentTitle ?? "")
//        display.text! = sender.currentTitle ?? ""
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }

    //assignment 1-2: add floating point input support
    @IBAction func touchPoint(_ sender: UIButton) {
        let text = display.text!
        
        if userIsInTheMiddleOfTyping {
            if !text.contains(".") {
                display.text = text + "."
            }
        } else {
            display.text = "0."
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!) ?? 0
        }
        set {
            // assignment 1 extra 2
            // Figure out from the documentation how to use the iOS struct
            // NumberFormatter to format your display so that it only shows 6
            // digits after the decimal point
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 6
            display.text = formatter.string(from: NSNumber(value: newValue))
        }
    }
    
    //Step 10, var for brain
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {

        //Step 8: Use the brain API
        //need to change: performOperation (it's calculating)
        //need not change: touchDigit (it's not calculating)
        //same to displayValue
//        userIsInTheMiddleOfTyping = false
//        if let mathSymbol = sender.currentTitle {
//            switch mathSymbol {
//            case "π":
//                displayValue = Double.pi
//            case "sqrt":
//                displayValue = sqrt(displayValue)
//            default:
//                break
//            }
//        }
        
        if userIsInTheMiddleOfTyping {
            //Step 9: want to set operand here, but where is my brain?
            //Define it in step 10
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(mathSymbol) //Step 11: Handing it off to brain
            //assignment 1-7
            if brain.resultIsPending {
                descriptionLabel.text = brain.description + " ..."
            } else {
                descriptionLabel.text = brain.description + " ="
            }
        }
        //Step 12: set display value to result
        if let result = brain.result {
            displayValue = result
        }
    }
    
    // assignment 1-8
    // Add a C button that clears everything (your display, the new UILabel you added above,
    // any pending binary operations, etc.).
    // Ideally, this should leave your Calculator in the same state it was in when you launched it.
    @IBAction func clear(_ sender: UIButton) {
        brain.clear()
        descriptionLabel.text = brain.description
        displayValue = 0
        //or I could setup a new brain
        //brain = CalculatorBrain()
    }

    
    // assignment 1 extra 1
    //Implement a “backspace” button for the user to touch if they hit the wrong digit button.
    @IBAction func touchBackspace(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            if let displayText = display.text {
                if displayText.characters.count > 1 {
                    display.text = String(displayText.dropLast())
                } else {
                    displayValue = 0
                    userIsInTheMiddleOfTyping = false
                }
            }
        }
    }
    
}

