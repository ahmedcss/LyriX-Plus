//
//  Test2.swift
//  LyriXPlus
//
//  Created by Aziz Bessrour on 4/16/17.
//  Copyright © 2017 Aziz Bessrour. All rights reserved.
//

import Foundation
import UIKit
import Speech
import Pulsator
import CDAlertView
class RecognitionController:UIViewController,SFSpeechRecognizerDelegate{
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    
    
    @IBOutlet weak var sourceView: UIImageView!
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))  //1
    let pulsator = Pulsator()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.textView.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor("#FF475C")
        pulsator.radius = 350.0
        pulsator.backgroundColor = UIColor(red: 0.921, green: 0.341, blue: 0.38, alpha: 1).cgColor
        pulsator.numPulse = 2
        
        
        
        microphoneButton.isEnabled = false  //2
        
        speechRecognizer?.delegate = self  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func microphoneTapped(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setTitle("Start Recording", for: .normal)
            pulsator.stop()
        } else {
            startRecording()
            microphoneButton.setTitle("Stop Recording", for: .normal)
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.sourceView.frame = CGRect(x: self.sourceView.frame.width, y: self.sourceView.frame.height, width: 250, height: 250)
                
                
                self.sourceView.frame = CGRect(x: (self.view.frame.width/2) - (self.sourceView.frame.width/2), y: (self.view.frame.height/2) - (self.sourceView.frame.height/2), width: self.sourceView.frame.width, height: self.sourceView.frame.height)
                self.microphoneButton.frame = CGRect(x: self.sourceView.frame.origin.x, y: self.sourceView.frame.origin.y, width: self.sourceView.frame.width, height: self.sourceView.frame.height)
                self.sourceView.layer.superlayer?.insertSublayer(self.pulsator, below: self.sourceView.layer)
                self.pulsator.position = self.sourceView.layer.position
 
            })
            pulsator.start()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
                self.microphoneTapped(self)
                
                if (self.textView.text.characters.count > 0){
                    let hello = self.storyboard?.instantiateViewController(withIdentifier: "SearchForMusic") as! SearchMusicController
                    
                    hello.searchedVal = self.textView.text!
                    print("Searchh : " + self.textView.text! )
                    hello.searchWith = "Lyrics"
                    self.navigationController?.pushViewController(hello, animated: true)
                }else{
                    CDAlertView(title: "Guess the song", message: "Try Again", type: .error).show()
                }
                
                
            })
        }
    }
    
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            //try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setMode(AVAudioSessionCategoryRecord)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = sourceView.layer.position
    }
    
   

}
