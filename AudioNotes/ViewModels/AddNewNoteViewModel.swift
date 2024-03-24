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
class AddNewNoteViewModel: ObservableObject {
    
    // MARK: - Private Properties
    
    let databaseService = FirebaseDatabaseService()
    
    // MARK: - Public Methods
    
    /**
     It uses iOS `SFSpeechRecognizer` API for converting given audio to text.
     Upcon successful coversion, it then returns the text via responseHandler callback
     */
    func convertAudioToText(responseHandler: @escaping ResponseHandler<String?>) {
        self.requestTranscribePermissions { hasPermission in
            guard hasPermission else {
                responseHandler(nil)
                return
            }
            
            guard let audioURL = Bundle.main.url(forResource: "harvard", withExtension: "wav") else {
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
        let note = NoteModel(id: UUID().uuidString, dateOfCreation: Date(), text: "Its a new note")
        self.databaseService.saveNoteToDatabase(note) { didSave in
            guard didSave else {
                responseHandler(nil)
                return
            }
            
            responseHandler(note)
        }
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
