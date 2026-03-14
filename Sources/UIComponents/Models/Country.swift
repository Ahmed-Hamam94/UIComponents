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
    
    /// Convenience initializer that generates the flag and localized name from an ISO country code.
    /// - Parameters:
    ///   - code: The ISO 3166-1 alpha-2 country code (e.g., "SA").
    ///   - dialCode: The international dial code (e.g., "+966").
    public init(code: String, dialCode: String) {
        self.id = UUID()
        self.code = code.uppercased()
        self.dialCode = dialCode
        self.flag = Self.flag(from: code)
        self.name = Self.localizedName(from: code)
    }
    
    public static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.code == rhs.code && lhs.dialCode == rhs.dialCode
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(code)
        hasher.combine(dialCode)
    }
    
    // MARK: - Native Helpers
    
    /// Generates an emoji flag from an ISO country code.
    private static func flag(from code: String) -> String {
        let base: UInt32 = 127397
        var s = ""
        for v in code.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return s
    }
    
    /// Gets the localized country name from an ISO country code.
    private static func localizedName(from code: String) -> String {
        Locale.current.localizedString(forRegionCode: code) ?? code
    }
}

// MARK: - Common Countries
public extension Country {
    /// Internal mapping of common ISO codes to their international dial codes.
    private static let dialCodeMap: [String: String] = [
        "SA": "+966", "US": "+1", "GB": "+44", "EG": "+20", "AE": "+971",
        "IN": "+91", "CA": "+1", "DE": "+49", "FR": "+33", "IT": "+39",
        "ES": "+34", "JP": "+81", "CN": "+86", "KR": "+82", "BR": "+55",
        "MX": "+52", "AU": "+61", "RU": "+7", "ZA": "+27", "TR": "+90",
        "KW": "+965", "QA": "+974", "BH": "+973", "OM": "+968", "JO": "+962",
        "LB": "+961", "MA": "+212", "PK": "+92", "BD": "+880", "ID": "+62"
    ]
    
    /// A comprehensive list of all supported countries, sorted alphabetically by localized name.
    static var all: [Country] {
        dialCodeMap.map { Country(code: $0.key, dialCode: $0.value) }
            .sorted { $0.name < $1.name }
    }
    
    static let saudiArabia = Country(code: "SA", dialCode: "+966")
    static let unitedStates = Country(code: "US", dialCode: "+1")
    static let unitedKingdom = Country(code: "GB", dialCode: "+44")
    static let egypt = Country(code: "EG", dialCode: "+20")
    static let uae = Country(code: "AE", dialCode: "+971")
    static let india = Country(code: "IN", dialCode: "+91")
    
    /// A curated subset of frequently used countries.
    static let commonCountries: [Country] = [
        .saudiArabia,
        .unitedStates,
        .unitedKingdom,
        .egypt,
        .uae,
        .india
    ]
}
