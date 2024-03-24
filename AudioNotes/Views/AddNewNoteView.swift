//
//  AddNewNoteView.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import SwiftUI

/**
 AddNewNoteViewDelegate manages the workflow after user saves a new note
 */
protocol AddNewNoteViewDelegate {
    func didSaveNewNote(_ note: NoteModel)
}

/**
 AddNewNoteView presents the user with UI/UX and functional flows for recording and saving a
 note.
 
 It uses APIs of both AudioManager and FirebaseDatabase to record and save the notes.
 */
struct AddNewNoteView: View {
    
    // MARK: Public Properties
    
    var delegate: AddNewNoteViewDelegate?
    
    // MARK: Private properties
    
    @EnvironmentObject private var overlayContainerContext: OverlayContainerContext
    @SwiftUI.Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel = AddNewNoteViewModel()
    
    // MARK: User interface
    
    var body: some View {
        ZStack {
            
            // Main Content
            VStack(alignment: .center, spacing: 24) {
                HStack {
                    // Back button
                    Button(
                        action: {
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white)
                                    .frame(width: 40, height: 40)
                                Image("leftArrowIcon")
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 37)
                                    .tint(Color.black)
                            }
                        }
                    )
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 100)
                
                // Record audio button
                Button(
                    action: {
                        print("Start audio recording...")
                    },
                    label: {
                        ZStack {
                            Image("micIconNormal")
                                .resizable()
                                .scaledToFit()
                                .opacity(1)
                                .frame(width: 100, height: 100)
                        }
                    }
                )
                
                // Save button
                
                Button(
                    action: {
                        self.overlayContainerContext.shouldShowProgressIndicator = true
                        self.viewModel.convertAudioToText { text in
                            self.overlayContainerContext.shouldShowProgressIndicator = false
                            guard let noteText = text else { return }
                            print(noteText)
                        }
                        
//                        self.overlayContainerContext.shouldShowProgressIndicator = true
//                        self.viewModel.saveNoteToDatabase { note in
//                            self.overlayContainerContext.shouldShowProgressIndicator = false
//                            guard let userNote = note else { return }
//                            self.delegate?.didSaveNewNote(userNote)
//                        }
                    },
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue)
                                .frame(width: 200, height: 40)
                            Text(
                                NSLocalizedString("Save", comment: "Add new note view - save button")
                            )
                            .font(.system(size: 16))
                            .foregroundColor(Color.white)
                        }
                    }
                )
                .padding(.bottom, 40)
                
                // Instructions text
                
                Text(
                    NSLocalizedString(
                        "Tap on the mic icon or long press the volume up key to record a new audio note.\n\nWhile audio recording is in progress, tap on the mic button again or long press volume down button to stop the recording.\n\nTo save the note, tap on the save buton.",
                        comment: "Add new note view - instruction text"
                    )
                )
                .font(.system(size: 18))
                .multilineTextAlignment(.leading)
                .foregroundColor(Color.black)
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
}
