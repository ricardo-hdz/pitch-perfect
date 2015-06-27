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
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioPlayer.prepareToPlay();
        
        // Initializes audioEngine and avAudioPlayers instances used to play the recorded audio with pitch effect
        audioEngine = AVAudioEngine()
        avAudioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
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
        self.stopAllAudio()
        playAudio(0.5)
    }
    
    /*
        Plays the audio using a rate of 2.0 (fast)
        :param sender
    */
    @IBAction func playFast(sender: UIButton) {
        self.stopAllAudio()
        playAudio(2.0)
    }
    
    /*
        Stops all audio
        :param sender
    */
    @IBAction func stopAudio(sender: UIButton) {
        self.stopAllAudio()
    }

    /*
        Plays the audio with a fixed pitch value (1000)
        :param sender
    */
    @IBAction func playChipmunkAudio(sender: UIButton) {
        self.stopAllAudio()
        playAudioWithVariablePitch(1000)
    }
    
    /*
        Plays the audio with a fixed pitch value (2000)
        :param sender
    */
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        self.stopAllAudio()
        playAudioWithVariablePitch(-1000)
    }
    
    /*
        Stops the audio player & engine to avoid sound overlap.
    */
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
    }
    
    /*
        Plays the recorded audio with a given pitch rate.
        :param: pitch The variable pitch rate the audio will be played at.
    */
    func playAudioWithVariablePitch(pitch: Float) {
        self.stopAllAudio()
        
        var pitchPlayer = AVAudioPlayerNode()
        var timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        
        audioEngine.attachNode(pitchPlayer)
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        pitchPlayer.scheduleFile(avAudioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        pitchPlayer.play()
    }
}
