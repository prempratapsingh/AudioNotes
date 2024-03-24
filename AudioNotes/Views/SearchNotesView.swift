//
//  SearchNotesView.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import SwiftUI

/**
 SearchNotesView helps user search for notes based on search text and presents
 list of matching notes.
 */
struct SearchNotesView: View {
    
    // MARK: - Public Properties
    
    var notes: [NoteModel]
    
    // MARK: - Private properties
    
    @SwiftUI.Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel = SearchNotesViewModel()
    @State private var searchString: String = ""
    
    @State private var shouldShowNoteDetailsView = false
    @State private var selectedNote: NoteModel?
    
    @State private var count: Int = 0
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // MARK: - User Interface
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main Content
                VStack(alignment: .center, spacing: 12) {
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
                    .overlay(content: {
                        Text(NSLocalizedString("Search Notes", comment: "Search notes view - title"))
                            .font(.system(size: 18))
                            .foregroundColor(Color.black)
                            .padding(.horizontal, 24)
                    })
                    
                    // Search input text field
                    SearchWidgetView(searchString: self.$searchString, delegate: self)
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                    
                    
                    // Search results
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(self.viewModel.searchResults, id: \.self.id) { note in
                                NoteWidgetView(note: note)
                                    .onTapGesture {
                                        self.selectedNote = note
                                        self.shouldShowNoteDetailsView = true
                                    }
                            }
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 60)
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
            }
            .onAppear {
                self.viewModel.allNotes = self.notes
            }
            .onChange(of: self.searchString) { searchString in
                self.stopTimer()
                self.startTimer()
            }
            .onReceive(self.timer) { _ in
                self.count += 1
                if self.count == 1 {
                    self.stopTimer()
                    self.viewModel.searchNotes(with: self.searchString)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(
                isPresented: self.$shouldShowNoteDetailsView,
                destination: {
                    NoteDetailsView(note: self.selectedNote)
                        .navigationBarHidden(true)
                }
            )
        }
    }
    
    // MARK: Private methods
    
    /// Stops the running timer and sets the tracking value count to 0
    private func stopTimer() {
        self.count = 0
        self.timer.upstream.connect().cancel()
    }

    /// Starts the timer with 1 second of delay
    func startTimer() {
        self.timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    }
}

// MARK: - SearchWidgetViewDelegate delegate methods

extension SearchNotesView: SearchWidgetViewDelegate {
    func didTapOnSearchButton() {
        print("didTapOnSearchButton")
    }
    
    func didCancelSearch() {
        self.viewModel.clearSearchResults()
    }
}
