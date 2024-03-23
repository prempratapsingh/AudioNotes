//
//  NotesListView.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import SwiftUI

/**
 NotesListView presents the list of user notes, sorted by the date of creation.
 User can tap on any of the note to see notes details.
 */
struct NotesListView: View {
    
    // MARK: - Public Properties
    
    var notes: [NoteModel]
    
    // MARK: - Private Properties
    
    @State private var shouldShowAddNewNoteView = false
    @State private var shouldShowSearchNoteView = false
    @State private var shouldShowNoteDetailsView = false
    @State private var selectedNote: NoteModel?
    
    // MARK: - User Interface
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // Main Content
                VStack(alignment: .center, spacing: 16) {
                    
                    // Tool bar
                    HStack {
                        
                        Text(NSLocalizedString("My Notes", comment: "Notes list view - title"))
                            .font(.system(size: 24))
                            .foregroundColor(Color.blue)
                        
                        Spacer()
                        
                        // Record new note button
                        Button(
                            action: {
                                self.shouldShowAddNewNoteView = true
                            },
                            label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.white)
                                        .frame(width: 40, height: 40)
                                    Image("micIconNormal")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .tint(Color.black)
                                }
                            }
                        )
                        
                        // Search notes button
                        Button(
                            action: {
                                self.shouldShowSearchNoteView = true
                            },
                            label: {
                                ZStack {
                                    Image("searchIcon")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .tint(Color.black)
                                }
                            }
                        )
                        
                        
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                    
                    // Notes list
                    
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(self.notes, id: \.self.id) { note in
                                NoteWidgetView(note: note)
                                    .onTapGesture {
                                        self.selectedNote = note
                                        self.shouldShowNoteDetailsView = true
                                    }
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                    .padding(.horizontal, 6)
                    .padding(.bottom, 24)
                }
            }
            .navigationDestination(
                isPresented: self.$shouldShowAddNewNoteView,
                destination: {
                    AddNewNoteView(delegate: self)
                        .navigationBarHidden(true)
                }
            )
            .navigationDestination(
                isPresented: self.$shouldShowSearchNoteView,
                destination: {
                    SearchNotesView()
                        .navigationBarHidden(true)
                }
            )
            .navigationDestination(
                isPresented: self.$shouldShowNoteDetailsView,
                destination: {
                    NoteDetailsView(note: self.selectedNote)
                        .navigationBarHidden(true)
                }
            )
        }
    }
}


// MARK: - AddNewNoteViewDelegate delegate methods

extension NotesListView: AddNewNoteViewDelegate {
    func didSaveNewNote(_ note: NoteModel) {
        self.shouldShowAddNewNoteView = false
    }
}
