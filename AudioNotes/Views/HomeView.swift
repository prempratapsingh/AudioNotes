//
//  ContentView.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import SwiftUI

/**
 HomeView is presented to the app user after the app splash screen.
 
 It connects to Firebase Database and checks if user has some previously created notes.
    If yes, The user is taken to the NotesListView
    If no, EmptyNotesView is presented where user can then record his/her first note.
 */
struct HomeView: View {
    
    // MARK: - Private Properties
    
    @EnvironmentObject private var overlayContainerContext: OverlayContainerContext
    @StateObject private var viewModel = HomeViewModel()
    @State private var shouldShowAddNewNoteView = false
    
    // MARK: User Interface
    
    var body: some View {
        NavigationView {
            ZStack {
                if self.viewModel.didAttemptToLoadNotesFromDatabase {
                    if !self.viewModel.userNotes.isEmpty {
                        NotesListView(notes: self.viewModel.userNotes)
                    } else {
                        EmptyNotesView(delegate: self)
                    }
                }
                
                // Link to add new note view
                NavigationLink(
                    destination:
                        AddNewNoteView(delegate: self)
                            .navigationBarHidden(true)
                    ,
                    isActive: self.$shouldShowAddNewNoteView
                ) { EmptyView() }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                guard self.viewModel.userNotes.isEmpty else { return }
                self.overlayContainerContext.shouldShowProgressIndicator = true
                self.viewModel.getUserNotes { _ in
                    self.overlayContainerContext.shouldShowProgressIndicator = false
                }
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

// MARK: - EmptyNotesViewDelegate delegate methods

extension HomeView: EmptyNotesViewDelegate {
    func didTapOnAddNewNoteButton() {
        self.shouldShowAddNewNoteView = true
    }
}

// MARK: - AddNewNoteViewDelegate delegate methods

extension HomeView: AddNewNoteViewDelegate {
    func didSaveNewNote(_ note: NoteModel) {
        self.shouldShowAddNewNoteView = false
        self.viewModel.addNewNote(note: note)
    }
}
