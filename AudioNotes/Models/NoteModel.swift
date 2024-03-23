//
//  NoteModel.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import Foundation

/**
 NoteModel is the data object that represents a user note saved in Firebase Database.
 This object has all the notes related details like id, creation date, note text, etc.
 */
class NoteModel: Codable {
    let id: String
    let dateOfCreation: Date
    let text: String
}
