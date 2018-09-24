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
    
    var utterance : AVSpeechUtterance
    let synthesizer : AVSpeechSynthesizer
    var voicesAvailable = [AVSpeechSynthesisVoice]()
    
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
            if( voice.language.hasPrefix("en-"))
            {
                /*
                 print(voice.name)
                 print(voice.identifier)
                 print(voice.language)
                 */
 
                voicesAvailable.append(voice)
            }

        }
  //      print("num of voices added \(voicesAvailable.count)" )
        utterance = AVSpeechUtterance(string: "Hello")
        utterance.voice = AVSpeechSynthesisVoice(identifier: voicesAvailable[currentVoice].identifier)
        synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func changeVoice()
    {
        currentVoice += 1
        if( currentVoice == voicesAvailable.count )
        {
            currentVoice = 0
        }
     //   print("voice number " + String(currentVoice))
        playKeyClick()
    }
    
    func playKeyClick()
    {
        AudioServicesPlaySystemSound(1104)
    }
    
    
    func stopSpeech()
    {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    func Say(content:String , stop:Bool)
    {
     //   print("say: " + content)
        if( stop )
        {
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        utterance = AVSpeechUtterance(string: content)
        utterance.voice = AVSpeechSynthesisVoice(identifier: voicesAvailable[currentVoice].identifier)
        synthesizer.speak(utterance)
    }
}
