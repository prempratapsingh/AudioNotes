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
    
    // MARK: Private Properties
    
    @EnvironmentObject private var overlayContainerContext: OverlayContainerContext
    @SwiftUI.Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel = AddNewNoteViewModel()
    
    @State private var scaleUpDownTimer: Timer? = nil
    @State private var shouldScaleUpRecordingButton: Bool = false
    
    // MARK: User Interface
    
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
                .overlay(content: {
                    Text(NSLocalizedString("Add New Note", comment: "Add new note view - title"))
                        .font(.system(size: 18))
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 24)
                })
                .padding(.horizontal, 12)
                .padding(.bottom, self.viewModel.noteText == nil ? 80 : 10)
                
                
                // Record audio button
                if self.viewModel.noteText == nil {
                    Button(
                        action: {
                            if self.viewModel.isRecoringInProgress {
                                self.scaleUpDownTimer?.invalidate()
                                self.scaleUpDownTimer = nil
                                
                                self.viewModel.stopAudioRecording()
                            } else {
                                self.scaleUpDownTimer = Timer.scheduledTimer(
                                    withTimeInterval: 0.5,
                                    repeats: true) { _ in
                                        self.shouldScaleUpRecordingButton.toggle()
                                }
                                self.viewModel.startAudioRecording()
                            }
                        },
                        label: {
                            if self.viewModel.isRecoringInProgress {
                                Image("micIconRecording")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .shadow(color: Color.red.opacity(0.7), radius: 5, x: 0, y: 0)
                                        .scaleEffect(self.shouldScaleUpRecordingButton ? 1.2 : 1)
                                        .animation(.easeOut(duration: 0.5), value: self.shouldScaleUpRecordingButton)
                            } else {
                                Image("micIconNormal")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                            }
                        }
                    )
                }
                
                if self.viewModel.didRecordAudio {
                    VStack(alignment: .leading, spacing: 16) {
                        if let noteText = self.viewModel.noteText, !noteText.isEmpty {
                            // Instructions text
                            Text(NSLocalizedString(
                                "Great, here is your text note,",
                                comment: "Add new note view - Here is your text note"
                            ))
                            .font(.system(size: 18))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black)
                            
                            ScrollView {
                                Text(noteText)
                                .font(.system(size: 18))
                                .multilineTextAlignment(.leading)
                                .foregroundColor(Color.gray)
                            }
                            .padding(.bottom, 16)
                            
                            // Save note button
                            Button(
                                action: {
                                    self.overlayContainerContext.shouldShowProgressIndicator = true
                                    self.viewModel.saveNoteToDatabase { note in
                                        self.overlayContainerContext.shouldShowProgressIndicator = false
                                        guard let userNote = note else { return }
                                        self.delegate?.didSaveNewNote(userNote)
                                    }
                                },
                                label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.blue)
                                            .frame(height: 40)
                                        Text(
                                            NSLocalizedString("Save note", comment: "Add new note view - save button")
                                        )
                                        .font(.system(size: 16))
                                        .foregroundColor(Color.white)
                                    }
                                }
                            )
                        } else {
                            // Instructions text
                            Text(NSLocalizedString(
                                "Awesome! your audio note is ready, tap on the button below to convert your audio note to text.",
                                comment: "Add new note view - Covert audio note to text note"
                            ))
                            .font(.system(size: 18))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black)
                            
                            // Convert audio to text button
                            Button(
                                action: {
                                    self.overlayContainerContext.shouldShowProgressIndicator = true
                                    self.viewModel.convertAudioToText { _ in
                                        self.overlayContainerContext.shouldShowProgressIndicator = false
                                    }
                                },
                                label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.blue)
                                            .frame(height: 40)
                                        Text(NSLocalizedString(
                                            "Convert audio note to text",
                                            comment: "Add new note view - convert audio to text button"
                                        ))
                                        .font(.system(size: 16))
                                        .foregroundColor(Color.white)
                                    }
                                }
                            )
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                } else {
                    // Instructions text
                    Text(
                        NSLocalizedString(
                            "Tap on the mic button to record a new audio note.\n\nWhile audio recording is in progress, tap on the mic button again to stop the recording.\n\nAfter your audio note is ready, tap on the convert to text button and than save button to save your note.",
                            comment: "Add new note view - instruction text"
                        )
                    )
                    .font(.system(size: 18))
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                    
                    Spacer()
                }
            }
        }
        .onDisappear {
            self.viewModel.resetToDefaultState()
        }
    }
}
