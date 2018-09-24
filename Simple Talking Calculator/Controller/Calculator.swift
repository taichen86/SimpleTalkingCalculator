//
//  Calculator.swift
//  KidsCalculator
//
//  Created by tai chen on 10/08/2018.
//  Copyright © 2018 BBMedia. All rights reserved.
//

import Foundation


protocol CalculatorDelegate
{
    func updateInputNumber( input : String )
    func say(input : String , stop : Bool)
    
}


class Calculator
{
    
    var delegate : CalculatorDelegate?
    
    enum Operation
    {
        case add
        case subtract
        case multiply
        case divide
        case equals
    }
    var operation = Operation.add
    let operations = [Operation.add, Operation.subtract, Operation.multiply, Operation.divide , Operation.equals]
    
    
    enum InputMode
    {
        case numbers
        case operation
    }
    var currentMode : InputMode
    var numbers = [Double]() // max of 2
    var currentInput : String
    
    var timer = Timer()
    var counter = 0
    @objc func updateTimer()
    {
    //    return
        if( currentMode == InputMode.operation ){ return }
        if( currentInput.count < 2 ){ return }
        counter += 1
     //   print("counter " + String(counter))
        // say whole input number
        if( counter == 2 )
        {
         //   print("SAY WHOLE NUM")
            delegate?.say(input: currentInput , stop: true)
        }
    }
    
    let formatter = NumberFormatter()
    init( )
    {
        currentMode = InputMode.operation
        numbers = []
        currentInput = ""
        timer = Timer.scheduledTimer(timeInterval: 0.86, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 50
    }
    
    var pointUsed = false
    func pointPressed()
    {
        
        // starting a number
        if( currentMode == InputMode.operation )
        {
         //   print("new number")
            reset()
            currentInput = "0"
        }
        
        if( pointUsed ){ return }
        pointUsed = true
        
        if( currentInput.count < 1 )
        {
        //    print("point not allowed")
            return
        }
        
        currentInput.append(".")
        delegate?.say(input: "point" , stop: true)
        delegate?.updateInputNumber(input: currentInput)
        
    }
    
    func clear()
    {
    //    print("clear")
        pointUsed = false
        currentMode = InputMode.numbers
        numbers = []
        currentInput = "0"
        numberCount = 0
   //     delegate?.updateInputNumber(input: "0")
    }
    
    
    func reset()
    {
        currentMode = InputMode.numbers
        if( operation == Operation.equals)
        {
            numbers = []
        }
        currentInput = ""
    }
    
    let numberCountLimit = 100
    var numberCount = 0
    func numberPressed( num : Int )
    {
     //   print("numberPressed " + String(num))
        counter = 0
        if( numberCount >= numberCountLimit )
        {
        //    print("reached number limit")
            return
        }
        delegate?.say(input: String(num) , stop:true)
        
        // starting a number
        if( currentMode == InputMode.operation )
        {
            reset()
        }

        
        currentInput.append(String(num))
       
        if( currentInput.count == 2 )
        {
            if( currentInput.first == "0" )
            {
             //   print("leading 0 remove")
                currentInput = String(currentInput.dropFirst())
            }
        }
   //     print("input " + currentInput)
        delegate?.updateInputNumber(input: currentInput)
        numberCount = currentInput.count
        
    }
    
    
    func operationPressed( tag : Int )
    {
    //    print("operation pressed \(tag)")
        numberCount = 0
        pointUsed = false

        if( currentMode == InputMode.numbers )
        {
            // save current number
            numbers.append(Double(currentInput)!)
         //   print("--> store number " + String(numbers[numbers.count-1]))
        }
        currentMode = InputMode.operation
    //    print(numbers.count)
        
        // remove trailing 0s after decimal
        removeTrailingZeros()
       
        // calculate
        if( numbers.count == 2 )
        {
         //   print("calculate " + String(numbers[0]) + "\(operation)" + String(numbers[1]))
            // switch statement here to calculate
            var result = 0.0
            switch operation
            {
            case Operation.add:
                result = numbers[0] + numbers[1]
            case Operation.subtract:
                result = numbers[0] - numbers[1]
            case Operation.multiply:
                result = numbers[0] * numbers[1]
            case Operation.divide:
                result = numbers[0] / numbers[1]
            default:
                print("equals")
            }
        //    print("RESULT " + String(result) )

            
            var formattedResult = String(result)
            
            
            if( tag == 5 )
            {
                formattedResult = formatter.string(for: result)!
             //   formattedResult = formattedResult.replacingOccurrences(of: ",", with: ".")
             //   print("formatted " + formattedResult)
                if( String(result) == "inf" ||  String(result) == "nan" )
                {
                    formattedResult = "undefined"
                }
                if( result < 1000000000000000.0 )
                {
                    delegate?.say(input: formattedResult , stop: false)
                }
             //   delegate?.say(input: String(format: "%g", result) , stop: false)
            }
            
            
            
            numbers = [result]
      //      print("reset input array, count " + String(numbers.count))
        //    currentInput = String(format: "%g", result)
            currentInput = formattedResult
            delegate?.updateInputNumber(input: currentInput)
        //    delegate?.updateInputNumber(input: String(format: "%g", result))
            
        }
        else
        {
        //    print("not well formatted yet")
        }
        
        operation = operations[tag-1]

        
    }
    
    
    func removeTrailingZeros()
    {
        // remove extra 0s after decimal
        let numArray = currentInput.split(separator: ".")
    //    print(numArray.count)
        if( numArray.count == 2 )
        {
            var newDecimal = ""
            var copying = false
            for char in numArray[1].reversed()
            {
                if( copying )
                {
                    newDecimal.append(String(char))
                }
                else
                {
                    if( char != "0" )
                    {
                        newDecimal.append(String(char))
                        copying = true
                    }
                }
            }
            if( newDecimal.count == 0 )
            {
                newDecimal = "0"
            }
            newDecimal = String(newDecimal.reversed())
            currentInput = numArray[0] + "." + newDecimal
            delegate?.updateInputNumber(input: currentInput)
            
        }
    }

    
}
