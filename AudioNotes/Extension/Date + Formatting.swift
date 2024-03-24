//
//  Date + Formatting.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 24/03/24.
//

import Foundation

extension Date {
    
    /**
     Returns formatted date string for user note creation date/time value
     */
    var formattedDateAndTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, E hh:mm a"
        let formattedDateString = formatter.string(from: self)
        return formattedDateString
    }
}
