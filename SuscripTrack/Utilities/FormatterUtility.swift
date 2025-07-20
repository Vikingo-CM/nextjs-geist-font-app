//
//  FormatterUtility.swift
//  SuscripTrack
//
//  Created on iOS App Development
//

import Foundation

struct FormatterUtility {
    
    // MARK: - Currency Formatter
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    // MARK: - Date Formatters
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let mediumDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let dayMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter
    }()
    
    // MARK: - Public Methods
    
    /// Formats a Double value as currency using the user's locale
    /// - Parameter amount: The amount to format
    /// - Returns: A formatted currency string
    static func formatCurrency(_ amount: Double) -> String {
        return currencyFormatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    /// Formats a Date as a short date string
    /// - Parameter date: The date to format
    /// - Returns: A formatted date string (e.g., "12/25/23")
    static func formatDate(_ date: Date) -> String {
        return shortDateFormatter.string(from: date)
    }
    
    /// Formats a Date as a medium date string
    /// - Parameter date: The date to format
    /// - Returns: A formatted date string (e.g., "Dec 25, 2023")
    static func formatMediumDate(_ date: Date) -> String {
        return mediumDateFormatter.string(from: date)
    }
    
    /// Formats a Date as day and month only
    /// - Parameter date: The date to format
    /// - Returns: A formatted date string (e.g., "Dec 25")
    static func formatDayMonth(_ date: Date) -> String {
        return dayMonthFormatter.string(from: date)
    }
    
    /// Formats a Date as a full date string
    /// - Parameter date: The date to format
    /// - Returns: A formatted date string (e.g., "Monday, December 25, 2023")
    static func formatFullDate(_ date: Date) -> String {
        return fullDateFormatter.string(from: date)
    }
    
    /// Calculates and formats the percentage of a part relative to the whole
    /// - Parameters:
    ///   - part: The part value
    ///   - whole: The whole value
    /// - Returns: A formatted percentage string (e.g., "25%")
    static func formatPercentage(_ part: Double, of whole: Double) -> String {
        guard whole > 0 else { return "0%" }
        let percentage = (part / whole) * 100
        return String(format: "%.0f%%", percentage)
    }
    
    /// Formats a number with appropriate decimal places
    /// - Parameter number: The number to format
    /// - Returns: A formatted number string
    static func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }
    
    /// Calculates the number of days between two dates
    /// - Parameters:
    ///   - from: The start date
    ///   - to: The end date
    /// - Returns: The number of days between the dates
    static func daysBetween(from: Date, to: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: from, to: to)
        return components.day ?? 0
    }
    
    /// Formats the days until a future date
    /// - Parameter date: The future date
    /// - Returns: A formatted string describing days until the date
    static func formatDaysUntil(_ date: Date) -> String {
        let days = daysBetween(from: Date(), to: date)
        
        if days < 0 {
            return "Overdue"
        } else if days == 0 {
            return "Today"
        } else if days == 1 {
            return "Tomorrow"
        } else {
            return "In \(days) days"
        }
    }
    
    /// Validates if a string can be converted to a valid currency amount
    /// - Parameter string: The string to validate
    /// - Returns: True if the string represents a valid currency amount
    static func isValidCurrencyString(_ string: String) -> Bool {
        guard let _ = Double(string.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return false
        }
        return true
    }
    
    /// Converts a currency string to a Double value
    /// - Parameter string: The currency string to convert
    /// - Returns: The Double value or nil if conversion fails
    static func currencyStringToDouble(_ string: String) -> Double? {
        let cleanedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(cleanedString)
    }
}

// MARK: - Extensions for convenience
extension Double {
    /// Formats the Double as currency using FormatterUtility
    var asCurrency: String {
        return FormatterUtility.formatCurrency(self)
    }
    
    /// Formats the Double as a number using FormatterUtility
    var asNumber: String {
        return FormatterUtility.formatNumber(self)
    }
}

extension Date {
    /// Formats the Date as a short date using FormatterUtility
    var asShortDate: String {
        return FormatterUtility.formatDate(self)
    }
    
    /// Formats the Date as a medium date using FormatterUtility
    var asMediumDate: String {
        return FormatterUtility.formatMediumDate(self)
    }
    
    /// Formats the Date as day and month using FormatterUtility
    var asDayMonth: String {
        return FormatterUtility.formatDayMonth(self)
    }
    
    /// Returns the number of days until this date
    var daysUntil: String {
        return FormatterUtility.formatDaysUntil(self)
    }
}
