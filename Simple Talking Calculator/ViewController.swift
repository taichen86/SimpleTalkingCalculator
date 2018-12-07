//
//  ViewController.swift
//  KidsCalculator
//
//  Created by tai chen on 09/08/2018.
//  Copyright © 2018 BBMedia. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController , CalculatorDelegate
{

    @IBOutlet weak var settingsTV: UITableView!
    var numOfLanguages : Int = 1
    
    
    func updateInputNumber(input: String)
    {
        var size = 74
        if( input.count > 6 )
        {
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
        speaker.stopSpeech()
        speaker.Say(content: input)
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
    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet weak var displayTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var keypadTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var settingViewWidth: NSLayoutConstraint!
    
    @IBAction func settingsButtonPressed(_ sender: UIButton)
    {
        toggleSettingsView()
    }
    
    var settingsViewOpen = false
    func toggleSettingsView()
    {
        UIView.animate(withDuration: 0.13) {
            self.settingViewWidth.constant = self.settingsViewOpen ? 0 : 240
            self.keypadTrailingConstraint.constant = self.settingsViewOpen ? 0 : -240
            self.displayTrailingConstraint.constant = self.settingsViewOpen ? 0 : -240
            self.view.layoutIfNeeded()
        }
        settingsViewOpen = !settingsViewOpen
    }
    
    @IBOutlet weak var muteButton: UIButton!
    @IBAction func muteButtonPressed(_ sender: UIButton)
    {
        AudioServicesPlaySystemSound(1104)
        voiceON = !voiceON
        UserDefaults.standard.set(voiceON, forKey: "voiceON")
        updateMuteButton()
    }
    
    func updateMuteButton()
    {
   //     print("voiceON \(voiceON)")
        if voiceON{
            muteButton.setImage(UIImage(named: "voiceON"), for: .normal)
            muteButton.alpha = 1.0
            speaker.setVolume(1.0)
        }else{
            muteButton.setImage(UIImage(named: "voiceOFF"), for: .normal)
            muteButton.alpha = 0.7
            speaker.setVolume(0.0)
        }
    }
    
    
    @IBOutlet weak var voiceButton: UIButton!
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
        if( currentColor == bgColors.count ){
            currentColor = 0
        }
        // update colors
        for btn in allNumberButons {
            btn.backgroundColor = bgColors[currentColor]
            btn.setTitleColor(textColors[currentColor], for: .normal)
        }
        
        for btn in allOperationButons {
            btn.backgroundColor = bgColorsDarker[currentColor]
            btn.setTitleColor(textColors[currentColor], for: .normal)
        }
 
    }
    
    
    @IBAction func pressedOperatorButton(_ sender: UIButton){
   //     speaker.Say(content: sender.accessibilityLabel! , stop: true)
        speaker.stopSpeech()
        speaker.Say(content: Translations.words[sender.accessibilityLabel!]?[speaker.currentLanguage] ?? "")
        calculator.operationPressed(tag: sender.tag)
    }
    
    @IBAction func pressed(_ sender: UIButton) {
        let text = sender.currentTitle!
        calculator.numberPressed(num: Int(text)!)
    }
    let userdefaults = UserDefaults.standard
    let calculator = Calculator()
    let speaker = Speaker()
    var voiceON = true
    override func viewDidLoad() {
        super.viewDidLoad()

        calculator.delegate = self
        settingsTV.delegate = self
        settingsTV.dataSource = self
        settingsTV.reloadData()
        if let key = userdefaults.object(forKey: "voiceON") as? Bool {
            voiceON = key
        }else{ userdefaults.set(true, forKey: "voiceON") }
        updateMuteButton()
        speaker.setPreviousVoice()
        showWelcome()
        tableView(settingsTV, didSelectRowAt: [Array(speaker.allVoices.keys).index(of: speaker.currentLanguage)!,speaker.currentVoice])
  //      print("select row \([Array(speaker.allVoices.keys).index(of: speaker.currentLanguage)!,speaker.currentVoice])")
    //      speaker.Say(content: Translations.words["hello"]?[speaker.currentLanguage] ?? "hello" , stop: false)
    }
    
    func display(input : String) {
        displayLabel.text = input
    }
    
    func showWelcome()
    {
        display(input: Translations.words["hello"]?[speaker.currentLanguage] ?? "hello")
    }


}

extension ViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return speaker.allVoices.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Translations.languages[Array(speaker.allVoices)[section].key] ?? Array(speaker.allVoices)[section].key
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(speaker.allVoices)[section].value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = Array(speaker.allVoices)[indexPath.section].value[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    print("select row \(indexPath)")
        speaker.currentLanguage = Array(speaker.allVoices)[indexPath.section].key
        speaker.currentVoice = indexPath.row
        userdefaults.set(speaker.currentLanguage, forKey: "language")
        userdefaults.set(speaker.currentVoice, forKey: "voice")
   //     voiceNameLabel.text = Translations.languages[speaker.currentLanguage] ?? speaker.currentLanguage + "-" + speaker.allVoices[speaker.currentLanguage]![speaker.currentVoice].name
        speaker.stopSpeech()
        speaker.Say(content: Translations.words["hello"]?[speaker.currentLanguage] ?? "")
    }
}

