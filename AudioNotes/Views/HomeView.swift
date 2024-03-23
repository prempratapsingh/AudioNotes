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
    
    // MARK: User interface
    
    var body: some View {
        NavigationView {
            ZStack {
            }
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                self.overlayContainerContext.shouldShowProgressIndicator = true
                self.viewModel.getUserNotes { didLoadNotes in
                    
                }
            }
        }
        .navigationBarHidden(true)
    }
}
