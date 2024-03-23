//
//  UIDevice + UUID.swift
//  AudioNotes
//
//  Created by Prem Pratap Singh on 23/03/24.
//

import UIKit

extension UIDevice {
    
    // UUID is the unique ID of the user iPhone and thus can be used for authentication purpose
    static var uuid: String? {
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return nil }
        return uuid
    }
}
