//
//  ViewController.swift
//  KidsCalculator
//
//  Created by tai chen on 09/08/2018.
//  Copyright © 2018 BBMedia. All rights reserved.
//

import UIKit


class ViewController: UIViewController , CalculatorDelegate
{

    func updateInputNumber(input: String)
    {
    //    print("update input number --> \(input)")
        var size = 74
        if( input.count > 6 )
        {
        //    print("smaller size " + String(input.count))
            size = 50
            if( input.count > 9 )
            {
                size = 32
                if( input.count > 14 )
                {
                    size = 24
                    if( input.count > 19 )
                    {
                        size = 16
                    }
                }
                
                
                
            }
        }
 
        
        
        displayLabel.font = displayLabel.font.withSize(CGFloat(size))
        displayLabel.text = input
    }
    
    func say( input: String , stop:Bool )
    {
        speaker.Say(content: input , stop: stop)
    }
    
    
    @IBAction func pointButtonPressed(_ sender: UIButton)
    {
        calculator.pointPressed()
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton)
    {
        calculator.clear()
        updateInputNumber(input: "0")
        speaker.stopSpeech()
        speaker.playKeyClick()
    }
    
    @IBOutlet var allNumberButons : [UIButton]!
    @IBOutlet var allOperationButons : [UIButton]!
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBAction func pressedVoiceButton(_ sender: UIButton)
    {
        speaker.stopSpeech()
        speaker.changeVoice()
    }
   
    var currentColor = 0
    
    let bgColorsDarker = [ UIColor(red: 170.0/255.0, green: 225.0/255.0, blue: 240.0/255.0, alpha: 1.0 ) , UIColor(red: 235.0/255.0, green: 185.0/255.0, blue: 225.0/255.0, alpha: 1.0) , UIColor(red: 200.0/255.0, green: 185.0/255.0, blue: 235.0/255.0, alpha: 1.0 ) ]
    let bgColors = [ UIColor(red: 185.0/255.0, green: 240.0/255.0, blue: 255.0/255.0, alpha: 1.0 ) , UIColor(red: 255.0/255.0, green: 200.0/255.0, blue: 245.0/255.0, alpha: 1.0) , UIColor(red: 215.0/255.0, green: 200.0/255.0, blue: 255.0/255.0, alpha: 1.0) ]
    let textColors = [ UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0) , UIColor(red: 0.0/255.0, green: 185.0/255.0, blue: 255.0/255.0, alpha: 1.0) , UIColor(red:250.0/255.0, green:255.0/255.0, blue:0.0/255.0, alpha:1.0 )]
    @IBAction func pressedColorButton(_ sender: UIButton)
    {
        speaker.playKeyClick()
        currentColor += 1
        if( currentColor == bgColors.count )
        {
            currentColor = 0
        }
        // update colors
        for btn in allNumberButons
        {
            btn.backgroundColor = bgColors[currentColor]
            btn.setTitleColor(textColors[currentColor], for: .normal)
        }
        
        for btn in allOperationButons
        {
            btn.backgroundColor = bgColorsDarker[currentColor]
            btn.setTitleColor(textColors[currentColor], for: .normal)
        }
 
    }
    
    
    @IBAction func pressedOperatorButton(_ sender: UIButton)
    {
        speaker.Say(content: sender.accessibilityLabel! , stop: true)
        calculator.operationPressed(tag: sender.tag)
    }
    
    @IBAction func pressed(_ sender: UIButton)
    {
        let text = sender.currentTitle!
    //    print("pressed: " + text)
    //    speaker.Say(content: text)
        calculator.numberPressed(num: Int(text)!)
    }
    
    let calculator = Calculator()
    let speaker = Speaker()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        calculator.delegate = self
    }
    
   
    
    func display(input : String)
    {
    //    print("display " + input)
        displayLabel.text = input
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

