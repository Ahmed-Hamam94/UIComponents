//
//  Country.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 24/01/2026.
//

import Foundation

/// A data model representing a country for use in phone number pickers and address forms.
public struct Country: Identifiable, Equatable, Hashable, Sendable {
    public let id: UUID
    /// The ISO 3166-1 alpha-2 country code (e.g., "SA", "US").
    public let code: String
    /// The emoji representation of the country's flag (e.g., "🇸🇦", "🇺🇸").
    public let flag: String
    /// The international dial code prefix (e.g., "+966", "+1").
    public let dialCode: String
    /// The full localized name of the country.
    public let name: String
    
    public init(code: String, flag: String, dialCode: String, name: String, id: UUID = UUID()) {
        self.id = id
        self.code = code
        self.flag = flag
        self.dialCode = dialCode
        self.name = name
    }
    
    public static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.code == rhs.code && lhs.dialCode == rhs.dialCode
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(code)
        hasher.combine(dialCode)
    }
}

// MARK: - Common Countries
public extension Country {
    static let saudiArabia = Country(code: "SA", flag: "🇸🇦", dialCode: "+966", name: "Saudi Arabia")
    static let unitedStates = Country(code: "US", flag: "🇺🇸", dialCode: "+1", name: "United States")
    static let unitedKingdom = Country(code: "GB", flag: "🇬🇧", dialCode: "+44", name: "United Kingdom")
    static let egypt = Country(code: "EG", flag: "🇪🇬", dialCode: "+20", name: "Egypt")
    static let uae = Country(code: "AE", flag: "🇦🇪", dialCode: "+971", name: "United Arab Emirates")
    static let india = Country(code: "IN", flag: "🇮🇳", dialCode: "+91", name: "India")
    
    static let commonCountries: [Country] = [
        .saudiArabia,
        .unitedStates,
        .unitedKingdom,
        .egypt,
        .uae,
        .india
    ]
}
