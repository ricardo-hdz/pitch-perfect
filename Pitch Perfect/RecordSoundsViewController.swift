//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ricardo Hdz on 6/13/15.
//  Copyright (c) 2015 Ricardo Hdz. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    /*
        Outlets
        - recordLabel
        - stopButton
        - recordButton
    */
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    /*
        Constants for UILabel text
    */
    let tapToRecordText = "Tap to record"
    let recordingText = "Recording..."
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!

    /*
        Initializes the view and set up the default view
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        recordLabel.text = tapToRecordText
    }
    
    /*
        Resets the CTA label after the view disappears
    */
    override func viewDidDisappear(animated: Bool) {
        recordLabel.text = tapToRecordText
    }
    
    /*
        Hides the view buttons before the view appears
        :param: animated
    */
    override func viewWillAppear(animated: Bool) {
        // Hide the stop button
        stopButton.hidden = true
        recordButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
        Records a pirce of audio using device's inout source

        :param: sender the record button initiaizing the recording
    */
    @IBAction func recordAudio(sender: UIButton) {
        // Update label and displau buttons
        recordLabel.text = recordingText
        stopButton.hidden = false
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let recordSettings = [
            AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0
        ]
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch _ {
            print("Error initializing session.setCategory")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(URL: filePath!, settings: recordSettings as! [String : AnyObject])
        } catch {
            print("Error initializing AVAudioRecorder")
        }

        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    /*
        Stops the recording session
    
        :param: sender The UI button to stop audio recording
    */
    @IBAction func stopAudio(sender: UIButton) {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
            print("Error activating audioSession")
        }
    }
    
    /*
        Delegate function to handle finish recording event and to send the audio recorded to the next view via segue.

        :param: recorder
        :param: flag
    */
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("An error ocurred while recording")
        }
    }
    
    /*
        Prepares the app for next segue and send the audio data (of class RecordedAudio) to PlaySoundsViewController
        :param: segue
        :param: sender

    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    


}

