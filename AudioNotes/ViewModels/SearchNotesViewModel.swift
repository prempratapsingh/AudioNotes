//
//  SearchNotesViewModel.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import Foundation

/**
 SearchNotesViewModel provides notes search related business logic to the search view
 */
class SearchNotesViewModel: ObservableObject {
    
    // MARK: - Public Properties
    
    @Published var didSearchForItems: Bool = false
    @Published var isSearchResultEmpty: Bool = false
    @Published var searchResults: [NoteModel] = []
    
    var allNotes = [NoteModel]()
    
    // MARK: - Public Methods
    
    /**
     Looks for notes with text matching user entered search text
     */
    func searchNotes(with searchText: String) {
        guard !searchText.isEmpty else {
            self.clearSearchResults()
            return
        }
        for note in self.allNotes {
            if note.text.lowercased().contains(searchText.lowercased()) {
                if self.searchResults.first(where: {$0.id == note.id}) == nil {
                    self.searchResults.append(note)
                }
            } else {
                if let index = self.searchResults.firstIndex(where: {$0.id == note.id}) {
                    self.searchResults.remove(at: index)
                }
            }
        }
        
        self.didSearchForItems = true
        self.isSearchResultEmpty = self.searchResults.isEmpty
    }
    
    /**
     Resets search result to default state
     */
    func clearSearchResults() {
        self.didSearchForItems = false
        self.isSearchResultEmpty = false
        self.searchResults.removeAll()
    }
}
