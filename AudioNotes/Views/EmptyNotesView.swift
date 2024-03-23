//
//  EmptyNotesView.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import SwiftUI

/**
 EmptyNotesViewDelegate manages the workflow of presenting add new notes view after the user
 taps on the add new notes button
 */
protocol EmptyNotesViewDelegate {
    func didTapOnAddNewNoteButton()
}

/**
 EmptyNotesView is presented when user doesn't have any notes saved in Firebase Database.
 It allows the user to record his/her first note.
 */
struct EmptyNotesView: View {
    
    // MARK: - Public Properties
    
    var delegate: EmptyNotesViewDelegate?
    
    // MARK: - User Interface
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            Spacer()
            
            Text(
                NSLocalizedString(
                    "Audio notes app simplifies the workflow for taking notes and working with them later.\n\nTap on the take new note button to start.",
                    comment: "Empty notes view - description"
                )
            )
            .font(.system(size: 18))
            .multilineTextAlignment(.leading)
            .foregroundColor(Color.black)
            
            Button(
                action: {
                    self.delegate?.didTapOnAddNewNoteButton()
                },
                label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue)
                            .frame(width: 200, height: 40)
                        Text(
                            NSLocalizedString("Add a note", comment: "Empty notes view - Add new note title")
                        )
                        .font(.system(size: 16))
                        .foregroundColor(Color.white)
                    }
                }
            )
            .padding(.top, 40)
            
            Spacer()
        }
    }
}
