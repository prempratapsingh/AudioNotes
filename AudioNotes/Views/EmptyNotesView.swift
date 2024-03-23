//
//  EmptyNotesView.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import SwiftUI

/**
 EmptyNotesView is presented when user doesn't have any notes saved in Firebase Database.
 It allows the user to record his/her first note.
 */
struct EmptyNotesView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}
