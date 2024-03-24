//
//  HomeViewModel.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import Foundation

/**
 HomeViewModel works as a view model for the HomeView and it provides business logic related to,
 1. Communication with Firebase Database to load user saved notes
 */
class HomeViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    @Published var userNotes = [NoteModel]()
    @Published var didAttemptToLoadNotesFromDatabase = false
    
    // MARK: - Public Methods
    
    /**
     This method uses FirebaseDatabase service to get the list of user saved notes
     */
    func getUserNotes(responseHandler: @escaping ResponseHandler<Bool>) {
        let databaseService = FirebaseDatabaseService()
        databaseService.loadNotesFromDatabase { notes in
            self.didAttemptToLoadNotesFromDatabase = true
            
            guard !notes.isEmpty else {
                responseHandler(false)
                return
            }
            
            self.userNotes.removeAll()
            //let sorteddNotesByCreationDate = notes.sorted(by: { $0.dateOfCreation.timeIntervalSince1970 > $1.dateOfCreation.timeIntervalSince1970 })
            self.userNotes.append(contentsOf: notes)
            self.sortNotesByCreationDate()
            responseHandler(true)
        }
    }
    
    /**
     Add the given note object to the list of existing notes and then sort by note creation date and time
     */
    func addNewNote(note: NoteModel) {
        self.userNotes.append(note)
        self.sortNotesByCreationDate()
    }
    
    // MARK: - Private Methods
    
    /**
     Sorts notes based on their creation date and time
     */
    private func sortNotesByCreationDate() {
        self.userNotes.sort(by: { $0.dateOfCreation.timeIntervalSince1970 > $1.dateOfCreation.timeIntervalSince1970 })
    }
}
