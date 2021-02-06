//
//  DateFormatter.swift
//  Express
//
//  Created by Joseph Salazar Acuña on 23/1/21.
//

// Date Format Patterns: http://www.unicode.org/reports/tr35/tr35-dates.html#Date_Format_Patterns
import Foundation

final class DateUtil {
    // MARK: - Attributes
    
    private let calendar: Calendar
    private let formatter: DateFormatter
    static let shared = DateUtil()
    
    // MARK: Life Cycle
    
    private init() {
        self.calendar = Calendar.current
        self.formatter = DateFormatter()
        self.formatter.dateFormat = "EEEE d, MMM yy"
    }
    
    // MARK: Setup
    
    func getDateComponents(_ date: Date) -> [String] {
        self.formatter.dateFormat = "EEEE, d, MMMM"
        return self.formatter.string(from: date).split(separator: ",").map { String($0) }
    }
    
    func getEndDay(_ date: Date) -> Date? {
        return self.calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)
    }
    
    func getStartDay(_ date: Date) -> Date? {
        return self.calendar.startOfDay(for: date)
    }
    
    func getStringDate(_ date: Date) -> String {
        return self.formatter.string(from: date)
    }
    
    func getNumberOfdays(_ fromDate: Date, _ toDate: Date) -> Int {
        if let firstDate = self.calendar.date(bySettingHour: 12, minute: 0, second: 0, of: fromDate), let lastDate = self.calendar.date(bySettingHour: 12, minute: 0, second: 0, of: toDate) {
            return self.calendar.dateComponents([.day], from: firstDate, to: lastDate).day!
        }
        
        return -1
    }
}
