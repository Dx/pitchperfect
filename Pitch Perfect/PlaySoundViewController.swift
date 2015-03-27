//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Dx on 13/03/15.
//  Copyright (c) 2015 Palmera. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializes the audio player
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // Initializes the audio engine
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slowPressed(sender: AnyObject) {
        // This value changes the speed to be slower
        playWithDiferentRate(0.4)
    }
    
    @IBAction func fastPressed(sender: AnyObject) {
        // This value change the speed to be faster
        playWithDiferentRate(1.5)
    }
    
    @IBAction func stopPressed(sender: AnyObject) {
        // Just stop the audio player and engine
        stopAudioPlayerAndEngine()
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        // This value changes the pitch to sound like a chipmunk
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: AnyObject) {
        // This value changes the pitch to sound like darth vader
        playAudioWithVariablePitch(-1050)
    }
    
    // This is the function you were looking for in the previous code review ;)
    func stopAudioPlayerAndEngine() {
        //Stops the player and engine
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playWithDiferentRate(rate:Float) {
        stopAudioPlayerAndEngine()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopAudioPlayerAndEngine()
        
        // Attaches the audio player
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Attaches the pitch effect
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // Connect the player, the pitch effect and the output
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // Charges the audio file
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        // Play!
        audioPlayerNode.play()
    }
}
