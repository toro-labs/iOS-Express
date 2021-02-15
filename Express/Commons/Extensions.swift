//
//  Extensions.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 14/2/21.
//

import Foundation

extension Date {
    func localDate() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else { return Date() }

        return localDate
    }
}
