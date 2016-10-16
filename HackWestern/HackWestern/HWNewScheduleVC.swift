//
//  HWNewScheduleVC.swift
//  HackWestern
//
//  Created by Alex Nguyen on 2016-10-14.
//  Copyright © 2016 Alex Nguyen. All rights reserved.
//

import UIKit
import Speech
import UserNotifications

class HWNewScheduleVC: UIViewController, UITextViewDelegate {
    //-----------------
    // MARK: - IBOutlets
    //-----------------
    @IBOutlet weak var transcriptionTextView: UITextView!
    @IBOutlet weak var microphoneBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    
    //-----------------
    // MARK: - Variables
    //-----------------
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    //-----------------
    // MARK: - Initializers
    //-----------------
    override func viewDidLoad() {
        super.viewDidLoad()
        WebServices.shared.getAllAvailiableIndex {
            
        }
        //WebServices.shared.deleteMe()
        //WebServices.shared.refreshTableView(withScheduleId: 1)
        //WebServices.shared.getSchedule(withID: 1)
        hideKeyboardWhenTappedAround()
        transcriptionTextView.delegate = self
        UIApplication.shared.applicationIconBadgeNumber = -1
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            /*
             The callback may not be called on the main thread. Add an
             operation to the main queue to update the record button's state.
             */
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.microphoneBtn.isEnabled = true
                    
                case .denied:
                    self.microphoneBtn.isEnabled = false
                    self.transcriptionTextView.text = "Ooops! You need to allow speech recognition!"
                    
                case .restricted:
                    self.microphoneBtn.isEnabled = false
                    self.transcriptionTextView.text = "Ooops! You need to unrestrict speech recognition!"
                case .notDetermined:
                    self.microphoneBtn.isEnabled = false
                    self.transcriptionTextView.text = "Ooops! Speech recognition has not been authorized yet!"
                }
            }
        }
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge]) { (granted, error) in
            if (error == nil) {
                self.startNotifications()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func startNotifications(){
        let content = UNMutableNotificationContent()
        content.title = "New Pill!"
        content.body = "You have to take a new Advil pill in 20 minutes!"
        content.sound = UNNotificationSound.default()
        content.badge = Int(UIApplication.shared.applicationIconBadgeNumber + 1) as NSNumber?
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        let request = UNNotificationRequest(identifier: "20", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if error == nil {
                print("Add notification  succeeded")
            }
        }
    }
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                self.transcriptionTextView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneBtn.isEnabled = true
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        transcriptionTextView.text = "(Go ahead, I'm listening)"
    }
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneBtn.isEnabled = true
        } else {
            microphoneBtn.isEnabled = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    //-----------------
    // MARK: - Process Text
    //-----------------
    private func processQuery(text : String){
        LoadingScreenService.shared.presentLoadingView()
        WebServices.shared.getResponseFromServer(query: text) { (response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.transcriptionTextView.text = error
                }
            } else {
                DispatchQueue.main.async {
                    self.transcriptionTextView.text = "Great! We added that schedule to your calendar!"
                }
            }
            LoadingScreenService.shared.dismissLoadingView()
        }
    }
    //-----------------
    // MARK: - IBActions
    //-----------------
    @IBAction func microphoneBtnPressed(_ sender: AnyObject) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            createBtn.setTitle("Create", for: .normal)
            createBtn.isEnabled = true
        } else {
            try! startRecording()
            createBtn.setTitle("Recording", for: .normal)
            createBtn.isEnabled = false
        }
    }
    @IBAction func createBtnPressed(_ sender: AnyObject) {
        processQuery(text: transcriptionTextView.text)
    }
    
}
