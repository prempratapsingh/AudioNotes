//
//  NoteDetailsView.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 24/03/24.
//

import SwiftUI

/**
 Notes details view shows comprehensive details about a user selected note
 */
struct NoteDetailsView: View {
    
    // MARK: - Public Properties
    
    var note: NoteModel?
    
    // MARK: - Private Properties
    
    @SwiftUI.Environment(\.presentationMode) private var presentationMode
    
    // MARK: - User Interface
    
    var body: some View {
        ZStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 24) {
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
                    Text(NSLocalizedString("Note Details", comment: "Note details view - title"))
                        .font(.system(size: 18))
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 24)
                })
                .padding(.horizontal, 12)
                
                // Notes details
                if let userNote = self.note {
                    ScrollView {
                        Text("\(userNote.text)")
                            .font(.system(size: 16))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black)
                    }
                    .padding(.horizontal, 24)
                }
                
                Spacer()
            }
        }
    }
}
