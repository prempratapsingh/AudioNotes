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
    
    // MARK: - Private properties
    
    @SwiftUI.Environment(\.presentationMode) private var presentationMode
    
    // MARK: - User Interface
    
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
                
                Text(NSLocalizedString("Search Notes", comment: "Search notes view - title"))
                    .font(.system(size: 18))
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
}
