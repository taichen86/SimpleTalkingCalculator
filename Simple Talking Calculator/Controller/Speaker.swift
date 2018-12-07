//
//  Speaker.swift
//  KidsCalculator
//
//  Created by tai chen on 10/08/2018.
//  Copyright © 2018 BBMedia. All rights reserved.
//

import Foundation
import AVFoundation

class Speaker
{
    
    var utterance = AVSpeechUtterance()
    let synthesizer = AVSpeechSynthesizer()
    var voicesAvailable = [AVSpeechSynthesisVoice]()
    var allVoices = [String : [AVSpeechSynthesisVoice]]()
    
    var currentLanguage = "en" // set to english
    var currentVoice = 0
    
    init()
    {
    //    print("init speaker")
        for voice in AVSpeechSynthesisVoice.speechVoices()
        {

            /*
            print(voice.name)
            print(voice.identifier)
            print(voice.language)
 */
 
            let language = String(voice.language.prefix(2))
     //       print("language \(language)")
            
            if allVoices[language] == nil
            {
                allVoices[language] = [AVSpeechSynthesisVoice]()
            }
            allVoices[language]?.append(voice)

        }

    }
    
    var volume : Float = 1.0
    func setVolume(_ targetVolume:Float)
    {
        volume = targetVolume
    }

    func setPreviousVoice()
    {
        if let previousLanguage = UserDefaults.standard.string(forKey: "language"){
            if allVoices[previousLanguage] != nil {
                currentLanguage = previousLanguage
            }
        }
        
        let previousVoice = UserDefaults.standard.integer(forKey: "voice")
        if previousVoice < (allVoices[currentLanguage]?.count)! {
            currentVoice = previousVoice
       //     print("restore previous voice \(currentVoice)")
        }

        
    }
    
    func changeVoice()
    {
        currentVoice += 1
        if( currentVoice == allVoices[currentLanguage]?.count ){
            currentVoice = 0
        }
        UserDefaults.standard.set(currentVoice, forKey: "voice")
        playKeyClick()
        Say(content: Translations.words["hello"]?[currentLanguage] ?? "")
    }
    
    func playKeyClick()
    {
        AudioServicesPlaySystemSound(1104)
    }
    
    
    func stopSpeech()
    {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    func Say(content:String)
    {
        utterance = AVSpeechUtterance(string: content)
        utterance.voice = AVSpeechSynthesisVoice(identifier: allVoices[currentLanguage]![currentVoice].identifier)
        utterance.volume = volume
        synthesizer.speak(utterance)
    }
}
