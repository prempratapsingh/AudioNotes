//
//  SearchWidgetView.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 24/03/24.
//

import SwiftUI

/**
 SearchWidgetViewDelegate takes the required action when it is notified
 about user tap on the search button.
 */
protocol SearchWidgetViewDelegate {
    func didTapOnSearchButton()
    func didCancelSearch()
}

/**
 SearchWidgetView presents the search view link button with search icon and text
 */
struct SearchWidgetView: View {
    
    // MARK: Public properties
    
    @Binding var searchString: String
    var delegate: SearchWidgetViewDelegate?
    
    // MARK: User interface
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            // Background
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray200, lineWidth: 1)
                .frame(height: 44)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white)
                }
            
            // Main content
            HStack(alignment: .center, spacing: 12) {
                Image("searchIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                
                TextField(
                    NSLocalizedString("Search", comment: "Search view - title"),
                    text: self.$searchString
                )
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color.gray600)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                Spacer()
                
                if !self.searchString.isEmpty {
                    Button(
                        action: {
                            self.searchString = ""
                            self.delegate?.didCancelSearch()
                        },
                        label: {
                            ZStack(alignment: .trailing) {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 30, height: 30)
                                Image("crossIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 10)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

