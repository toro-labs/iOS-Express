//
//  Phone.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 6/2/21.
//

import Foundation
import SwiftUI

struct Phone {
    static func call(_ number: String) {
        if let phoneNumber = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(phoneNumber) {
            UIApplication.shared.open(phoneNumber, options: [:], completionHandler: nil)
        }
    }
}
