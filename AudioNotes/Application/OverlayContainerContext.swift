//
//  OverlayContainerContext.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import Foundation

/**
 OverlayContainerContext contains information about the overlay views and their properties like
 progress indicator view, alert view, etc
 */
class OverlayContainerContext: ObservableObject {
    @Published var shouldShowProgressIndicator = false
}
