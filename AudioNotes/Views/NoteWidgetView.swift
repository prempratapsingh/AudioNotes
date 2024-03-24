//
//  NoteWidgetView.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 24/03/24.
//

import SwiftUI

/**
 NoteWidgetView shows brief information about a user note in the notes list view
 */
struct NoteWidgetView: View {
    
    // MARK: - Public Properties
    
    var note: NoteModel
    
    // MARK: - User Interface
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray200)
                .frame(height: 80)
            
            HStack(alignment: .center, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(self.note.dateOfCreation.description)")
                        .font(.system(size: 12))
                        .foregroundColor(Color.black)
                    
                    Text("\(self.note.text)")
                        .font(.system(size: 16))
                        .truncationMode(.tail)
                        .foregroundColor(Color.black)
                        .frame(height: 40)
                        
                }
                
                
                Spacer()
                
                Image("rightArrowIcon")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 8, height: 13)
                    .tint(Color.black)
            }
            .padding(.all, 16)
        }
    }
}
