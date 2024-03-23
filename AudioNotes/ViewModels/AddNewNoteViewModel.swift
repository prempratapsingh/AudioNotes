//
//  AddNewNoteViewModel.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import Foundation

/**
 AddNewNoteViewModel manages business logic related to following use cases,
 1. Convert user recorded audio to text
 2. Saving notes text to Firebase database
 */
class AddNewNoteViewModel {
    
    // MARK: - Public Methods
    
    func convertAudioToText() {
        
    }
    
    func saveNoteToDatabase(responseHandlder: @escaping ResponseHandler<NoteModel?>) {
        let note = NoteModel()
        note.text = "Its a new note"
        responseHandlder(note)
    }
}
