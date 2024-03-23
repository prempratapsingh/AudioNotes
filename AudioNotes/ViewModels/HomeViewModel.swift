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
            self.userNotes.append(contentsOf: notes)
            responseHandler(true)
        }
    }
}
