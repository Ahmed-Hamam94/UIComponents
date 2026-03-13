//
//  PhoneNumberTextField.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 24/01/2026.
//

import SwiftUI

extension UI {
    /// A specialized text field for entering international phone numbers.
    ///
    /// The component includes a country picker with flags and dial codes.
    /// It supports custom themes via `UITextFieldThemeProtocol`.
    ///
    /// ```swift
    /// UI.PhoneNumberTextField(
    ///     phoneNumber: $phone,
    ///     selectedCountry: $country
    /// )
    /// ```
    public struct PhoneNumberTextField: View {
        /// A binding to the entered phone number string.
        @Binding private var phoneNumber: String
        /// A binding to the currently selected country.
        @Binding private var selectedCountry: Country
        
        /// The list of available countries in the picker.
        private let countries: [Country]
        /// The placeholder text shown in the phone number input.
        private let placeholder: String
        /// Whether to show the country's dial code in the selector.
        private let showCode: Bool
        /// Whether the text field is disabled.
        private let disabled: Bool
        /// The visual style of the text field.
        private let theme: UITextFieldThemeProtocol
        /// Optional accessibility overrides. Nil = use defaults.
        private let accessibility: UIAccessibility?
        private let width: CGFloat?
        private let height: CGFloat?
            
        public init(
            phoneNumber: Binding<String>,
            selectedCountry: Binding<Country>,
            countries: [Country] = Country.commonCountries,
            placeholder: String = "xxxxxxxx",
            showCode: Bool = true,
            disabled: Bool = false,
            theme: UITextFieldThemeProtocol = UITextFieldTheme(),
            accessibility: UIAccessibility? = nil,
            width: CGFloat? = nil,
            height: CGFloat? = nil
        ) {
            self._phoneNumber = phoneNumber
            self._selectedCountry = selectedCountry
            self.countries = countries
            self.placeholder = placeholder
            self.showCode = showCode
            self.disabled = disabled
            self.theme = theme
            self.accessibility = accessibility
            self.width = width
            self.height = height
        }
        
        // MARK: - Configuration-Based Initializer
        
        /// Creates a phone number text field using a configuration object.
        ///
        /// ```swift
        /// let config = PhoneNumberTextFieldConfig.usOnly
        /// UI.PhoneNumberTextField(
        ///     phoneNumber: $phone,
        ///     selectedCountry: $country,
        ///     config: config
        /// )
        /// ```
        public init(
            phoneNumber: Binding<String>,
            selectedCountry: Binding<Country>,
            config: PhoneNumberTextFieldConfig,
            theme: UITextFieldThemeProtocol = UITextFieldTheme(),
            accessibility: UIAccessibility? = nil
        ) {
            self._phoneNumber = phoneNumber
            self._selectedCountry = selectedCountry
            self.countries = config.countries
            self.placeholder = config.placeholder
            self.showCode = config.showCode
            self.disabled = config.disabled
            self.theme = theme
            self.accessibility = accessibility
            self.width = config.width
            self.height = config.height
        }
        
        private var hasMultipleCountries: Bool {
            countries.count > 1
        }
        
        /// Computed accessibility value showing current phone number with country code.
        private var accessibilityValue: String {
            if phoneNumber.isEmpty {
                return "Empty"
            }
            return "\(selectedCountry.dialCode) \(phoneNumber)"
        }
        
        public var body: some View {
            HStack(spacing: 0) {
                // Country Flag & Code Button
                countrySelector
                
                // Divider
                Rectangle()
                    .fill(theme.borderColor.opacity(0.5))
                    .frame(width: 1)
                    .padding(.vertical, 8)
                
                // Phone Number Input
                phoneInput
            }
            .frame(width: width, height: height ?? theme.height)
            .background(theme.backgroundColor)
            .clipShape(.rect(cornerRadius: theme.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadius)
                    .stroke(theme.borderColor, lineWidth: theme.borderWidth)
            )
            .opacity(disabled ? 0.6 : 1.0)
            .disabled(disabled)
            .accessibilityElement(children: .combine)
            .uiAccessibility(
                accessibility,
                defaultLabel: "Phone number",
                defaultValue: accessibilityValue,
                defaultHint: hasMultipleCountries ? "Select country and enter phone number" : "Enter phone number"
            )
        }
        
        // MARK: - Country Selector
        private var countrySelector: some View {
            Group {
                if hasMultipleCountries {
                    Menu {
                        ForEach(countries) { country in
                            SwiftUI.Button {
                                selectedCountry = country
                            } label: {
                                HStack {
                                    Text(country.flag)
                                    Text(country.name)
                                    Text(country.dialCode)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .accessibilityLabel("\(country.name), \(country.dialCode)")
                        }
                    } label: {
                        countrySelectorContent
                    }
                    .accessibilityLabel("Country selector")
                    .accessibilityHint("Double tap to select a different country")
                } else {
                    countrySelectorContent
                }
            }
        }
        
        private var countrySelectorContent: some View {
            HStack(spacing: 4) {
                Text(selectedCountry.flag)
                    .font(.title2)
                
                if showCode {
                    Text(selectedCountry.dialCode)
                        .font(theme.font)
                        .foregroundStyle(theme.textColor)
                }
                
                if hasMultipleCountries {
                    Image(systemName: theme.countrySelectorIcon)
                        .font(.caption)
                        .foregroundStyle(theme.placeholderColor)
                }
            }
            .padding(.horizontal, 12)
        }
        
        // MARK: - Phone Input
        private var phoneInput: some View {
            ZStack(alignment: .leading) {
                if phoneNumber.isEmpty {
                    Text(placeholder)
                        .font(theme.placeholderFont)
                        .foregroundStyle(theme.placeholderColor)
                }
                
                SwiftUI.TextField("", text: $phoneNumber)
                    .font(theme.font)
                    .foregroundStyle(theme.textColor)
                    #if os(iOS)
                    .keyboardType(.phonePad)
                    #endif
            }
            .padding(.horizontal, 12)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // Default with multiple countries
        UI.PhoneNumberTextField(
            phoneNumber: .constant(""),
            selectedCountry: .constant(.saudiArabia),
            width: 330,
            height: 60
        )
        
        // Single country (dropdown disabled)
        UI.PhoneNumberTextField(
            phoneNumber: .constant(""),
            selectedCountry: .constant(.saudiArabia),
            countries: [.saudiArabia]
        )
        
        // With custom theme
        UI.PhoneNumberTextField(
            phoneNumber: .constant("512345678"),
            selectedCountry: .constant(.uae),
            theme: UITextFieldTheme(
                backgroundColor: .white,
                borderColor: .blue,
                borderWidth: 1
            )
        )
        
        // Disabled state
        UI.PhoneNumberTextField(
            phoneNumber: .constant(""),
            selectedCountry: .constant(.egypt),
            disabled: true
        )
        
        // Without country code
        UI.PhoneNumberTextField(
            phoneNumber: .constant(""),
            selectedCountry: .constant(.unitedStates),
            showCode: false
        )
    }
    .padding()
}
