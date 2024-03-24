//
//  String + Date.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 24/03/24.
//

import Foundation

extension String {
    
    /**
     Returns date object from formatted date/time string value for user note creation date
     */
    var noteCreationDateFromString: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM y, E hh:mm a"
        let date = dateFormatter.date(from: self)
        return date
    }
}
