//
//  AudioNotesApp.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import SwiftUI
import Firebase

@main
struct AudioNotesApp: App {
    
    // MARK: - App delegate
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    // MARK: - Private properties
    
    @StateObject private var overlayContainerContext = OverlayContainerContext()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // Home view that shows after app splash screen
                HomeView()
                
                // Overlay (progress indicator, alert views, etc) container view
                OverlayContainerView()
            }
            .environmentObject(self.overlayContainerContext)
        }
    }
}
