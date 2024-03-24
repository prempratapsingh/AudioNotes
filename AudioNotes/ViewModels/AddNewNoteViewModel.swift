//
//  AddNewNoteViewModel.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import Foundation
import AVFoundation
import Speech

/**
 AddNewNoteViewModel manages business logic related to following use cases,
 1. Convert user recorded audio to text
 2. Saving notes text to Firebase database
 */
class AddNewNoteViewModel: NSObject, ObservableObject, AVAudioRecorderDelegate {
    
    // MARK: - Public Properties
    
    @Published var isRecoringInProgress = false
    @Published var didRecordAudio = false
    @Published var noteText: String?
    
    // MARK: - Private Properties
    
    let databaseService = FirebaseDatabaseService()
    
    private var audioFileUrl: URL?
    private let audioFileExtension = "m4a"
    private var audioRecorder: AVAudioRecorder?
    
    // MARK: - Public Methods
    
    func startAudioRecording() {
        guard !self.isRecoringInProgress else { return }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                self.isRecoringInProgress = false
                self.didRecordAudio = false
                return
            }

            let recordingFileName = UUID().uuidString.appending(".\(self.audioFileExtension)")
            self.audioFileUrl = documentsPath.appendingPathComponent(recordingFileName)
            self.audioRecorder = try AVAudioRecorder(url: self.audioFileUrl!, settings: settings)
            self.audioRecorder?.delegate = self
            self.audioRecorder?.record()
            
            self.isRecoringInProgress = true
            self.didRecordAudio = false
        } catch {
            print("[AudioService] Error starting audio recording")
            self.isRecoringInProgress = false
            self.didRecordAudio = false
        }
    }
    
    func stopAudioRecording() {
        guard self.isRecoringInProgress else { return }
        
        self.audioRecorder?.stop()
        self.isRecoringInProgress = false
        self.didRecordAudio = true
    }
    
    /**
     It uses iOS `SFSpeechRecognizer` API for converting given audio to text.
     Upcon successful coversion, it then returns the text via responseHandler callback
     */
    func convertAudioToText(responseHandler: @escaping ResponseHandler<String?>) {
        self.requestTranscribePermissions { hasPermission in
            guard hasPermission, let audioURL = self.audioFileUrl else {
                responseHandler(nil)
                return
            }

            let recognizer = SFSpeechRecognizer()
            let request = SFSpeechURLRecognitionRequest(url: audioURL)

            recognizer?.recognitionTask(with: request) { result, error in
                guard let result = result, error == nil else {
                    responseHandler(nil)
                    return
                }

                if result.isFinal {
                    let text = result.bestTranscription.formattedString
                    self.noteText = text
                    responseHandler(text)
                }
            }
        }
    }
    
    /**
     It uses FirebaseDatabase service API to save a new note object to Firebase database.
     It also returns the database operation sucess/failure state with the responseHandlder callback
     */
    func saveNoteToDatabase(responseHandler: @escaping ResponseHandler<NoteModel?>) {
        guard let noteText = self.noteText else {
            responseHandler(nil)
            return
        }
        
        let note = NoteModel(id: UUID().uuidString, dateOfCreation: Date(), text: noteText)
        self.databaseService.saveNoteToDatabase(note) { didSave in
            guard didSave else {
                responseHandler(nil)
                return
            }
            
            responseHandler(note)
        }
    }
    
    /**
     it resets the state to default
     */
    func resetToDefaultState() {
        self.audioFileUrl = nil
    }
    
    // MARK: - Private Methods
    
    /**
     It presents a prompt to the user requesting permission for using Speech framework
     */
    private func requestTranscribePermissions(responseHandler: @escaping ResponseHandler<Bool>) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    responseHandler(true)
                } else {
                    responseHandler(false)
                }
            }
        }
    }
}
