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
    
    // MARK: - Private properties
    
    @EnvironmentObject private var overlayContainerContext: OverlayContainerContext
    @StateObject private var viewModel = HomeViewModel()
    @State private var shouldShowAddNewNoteView = false
    
    private var addNewNoteViewModel = AddNewNoteViewModel()
    
    // MARK: User interface
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !self.viewModel.userNotes.isEmpty {
                    NotesListView(notes: self.viewModel.userNotes)
                } else {
                    EmptyNotesView(delegate: self)
                }
            }
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                self.overlayContainerContext.shouldShowProgressIndicator = false
                self.viewModel.getUserNotes { didLoadNotes in
                    
                }
            }
            .navigationDestination(
                isPresented: self.$shouldShowAddNewNoteView,
                destination: {
                    AddNewNoteView(delegate: self)
                        .navigationBarHidden(true)
                }
            )
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
    func didSaveNewNote() {
        self.shouldShowAddNewNoteView = false
        
        self.overlayContainerContext.shouldShowProgressIndicator = true
        self.addNewNoteViewModel.saveNoteToDatabase { note in
            self.overlayContainerContext.shouldShowProgressIndicator = false
            guard let savedNote = note else {
                return
            }
            
            self.viewModel.userNotes.append(savedNote)
        }
    }
}
