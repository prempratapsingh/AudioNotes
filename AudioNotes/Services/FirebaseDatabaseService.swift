//
//  FirebaseDatabaseService.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import Foundation
import Firebase
import FirebaseDatabase

/**
 FirebaseDatabaseService helps in setting up connection to the application Firebase database and
 perform CRUD operations (read, write, update, delete operations) for the notes data objects used in the app.
 */

class FirebaseDatabaseService {
    
    // MARK: - Private Properties
    
    let databaseUrl = "https://audionotes-e0011-default-rtdb.firebaseio.com/"
    
    // MARK: - Public Methods
    
    /// Saves user note in the Firebase database
    func saveNoteToDatabase(
        _ note: NoteModel,
        responseHandler: @escaping ResponseHandler<Bool>) {
            
            guard let deviceId = UIDevice.uuid else {
                responseHandler(false)
                return
            }
            
            let databaseReference: DatabaseReference = Database.database().reference(fromURL: self.databaseUrl)
            let userDeviceDirectory = databaseReference.child(NoteNodeProperties.nodeName).child(deviceId)
            let userNoteReference = userDeviceDirectory.child(note.id)
            
            let notesDetails: [String: Any] = [
                DatabaseNodeCommonProperties.id: note.id,
                NoteNodeProperties.dateOfCreation: note.dateOfCreation.description,
                NoteNodeProperties.text: note.text
            ]
            
            userNoteReference.setValue(notesDetails) { error, reference in
                guard error == nil else {
                    print("[Firebase Database] Failed to save note details for device \(deviceId)")
                    responseHandler(false)
                    return
                }
                print("[Firebase Database] Successfully saved note details for device \(deviceId)")
                responseHandler(true)
            }
        }
    
    /// Loads user notes from Firebase database
    func loadNotesFromDatabase(responseHandler: @escaping ResponseHandler<[NoteModel]>) {
        guard let deviceId = UIDevice.uuid else {
            responseHandler([])
            return
        }
        
        let databaseReference: DatabaseReference = Database.database().reference(fromURL: self.databaseUrl)
        let userDirectory = databaseReference.child(NoteNodeProperties.nodeName).child(deviceId)
        
        userDirectory.getData { error, snapshot in
            guard error == nil,
                  let dataSnapshot = snapshot,
                  dataSnapshot.exists(),
                  let notes = dataSnapshot.value as? [[String: Any]] else {
                print("[Firebase Database] Failed to load notes for device \(deviceId)")
                responseHandler([])
                return
            }
            
            var userNotes = [NoteModel]()
            for note in notes {
                if let id = note[DatabaseNodeCommonProperties.id] as? String, let dateOfCreation = note[NoteNodeProperties.dateOfCreation] as? String, let noteText = note[NoteNodeProperties.text] as? String {
                    let userNote = NoteModel(id: id, dateOfCreation: Date(), text: noteText)
                    userNotes.append(userNote)
                }
            }
            print("[Firebase Database] Successfully loaded notes for device \(deviceId)")
            responseHandler(userNotes)
        }
    }
}

/**
 DatabaseNodeCommonProperties defines common property names used
 for different nodes in Firebase Database.
 */
struct DatabaseNodeCommonProperties {
    static let id = "id"
    static let deviceId = "deviceId"
}

/**
 NoteNodeProperties defines properties related to the user note objects.
 */
struct NoteNodeProperties {
    static let nodeName = "Note"
    static let dateOfCreation = "dateOfCreation"
    static let text = "text"
}
