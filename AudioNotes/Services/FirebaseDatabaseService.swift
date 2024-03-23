//
//  FirebaseDatabaseService.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import Foundation

/**
 FirebaseDatabaseService helps in setting up connection to the application Firebase database and
 perform CRUD operations (read, write, update, delete operations) for the notes data objects used in the app.
 */

class FirebaseDatabaseService {
    
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
