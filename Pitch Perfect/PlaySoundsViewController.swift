//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ricardo Hdz on 6/16/15.
//  Copyright (c) 2015 Ricardo Hdz. All rights reserved.
//

import UIKit
import AVFoundation;

class PlaySoundsViewController: UIViewController {

    // Audio Player
    var audioPlayer = AVAudioPlayer()
    // Instance of RecorderAudio passed via RecordSoundsViewController
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var avAudioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        } catch {
            print("Error initializing AVAudioPlayer")
        }
        
        audioPlayer.enableRate = true
        audioPlayer.prepareToPlay();
        
        // Initializes audioEngine and avAudioPlayers instances used to play the recorded audio with pitch effect
        audioEngine = AVAudioEngine()
        do {
            avAudioFile = try AVAudioFile(forReading: receivedAudio.filePathUrl)
        } catch _ {
            avAudioFile = nil
            print("Error reading AVAudioFile")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
        Plays an audio file from teh beginning with the given rate.

        :param: speedRate The rate used to play the audio
    */
    func playAudio(speedRate: Float) {
        audioPlayer.stop()
        audioPlayer.rate = speedRate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    /*
        Plays the audio using a rate of 0.5 (slow)
        :param sender
    */
    @IBAction func playSlow(sender: UIButton) {
        audioPlayer.stop()
        playAudio(0.5)
    }
    
    /*
        Plays the audio using a rate of 2.0 (fast)
        :param sender
    */
    @IBAction func playFast(sender: UIButton) {
        audioPlayer.stop()
        playAudio(2.0)
    }
    
    /*
        Stops all audio
        :param sender
    */
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }

    /*
        Plays the audio with a fixed pitch value (1000)
        :param sender
    */
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    /*
        Plays the audio with a fixed pitch value (2000)
        :param sender
    */
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    /*
        Plays the recorded audio with a given pitch rate.
        :param: pitch The variable pitch rate the audio will be played at.
    */
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        
        let pitchPlayer = AVAudioPlayerNode()
        let timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        
        audioEngine.attachNode(pitchPlayer)
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        pitchPlayer.scheduleFile(avAudioFile, atTime: nil, completionHandler: nil)
        
        do {
            try audioEngine.start()
        } catch _ {
            print("Error starting audioEngine")
        }
        pitchPlayer.play()
    }
}
