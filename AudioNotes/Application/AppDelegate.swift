//
//  AppDelegate.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import Foundation
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.configureFirebase()
        return true
    }
    
    /**
     Configures Firebase services for the app
     */
    private func configureFirebase() {
        FirebaseApp.configure()
    }
}
