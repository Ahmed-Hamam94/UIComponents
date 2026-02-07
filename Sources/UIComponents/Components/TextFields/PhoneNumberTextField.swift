//
//  PhoneNumberTextField.swift
//  UIComponents
//
//  Created by Ahmed Hamam on 24/01/2026.
//

import SwiftUI

public struct PhoneNumberTextField: View {
    @Binding var phoneNumber: String
    @Binding var selectedCountry: Country
    
    let countries: [Country]
    let placeholder: String
    let showCode: Bool
    let disabled: Bool
    let theme: TextFieldThemeProtocol
        
    public init(
        phoneNumber: Binding<String>,
        selectedCountry: Binding<Country>,
        countries: [Country] = Country.commonCountries,
        placeholder: String = "xxxxxxxx",
        showCode: Bool = true,
        disabled: Bool = false,
        theme: TextFieldThemeProtocol = DesignTextFieldTheme()
    ) {
        self._phoneNumber = phoneNumber
        self._selectedCountry = selectedCountry
        self.countries = countries
        self.placeholder = placeholder
        self.showCode = showCode
        self.disabled = disabled
        self.theme = theme
    }
    
    private var hasMultipleCountries: Bool {
        countries.count > 1
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
        .frame(height: theme.height)
        .background(theme.backgroundColor)
        .clipShape(.rect(cornerRadius: theme.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: theme.cornerRadius)
                .stroke(theme.borderColor, lineWidth: theme.borderWidth)
        )
        .opacity(disabled ? 0.6 : 1.0)
        .disabled(disabled)
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
                    }
                } label: {
                    countrySelectorContent
                }
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
                Image(systemName: "chevron.down")
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

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        // Default with multiple countries
        PhoneNumberTextField(
            phoneNumber: .constant(""),
            selectedCountry: .constant(.saudiArabia)
        )
        
        // Single country (dropdown disabled)
        PhoneNumberTextField(
            phoneNumber: .constant(""),
            selectedCountry: .constant(.saudiArabia),
            countries: [.saudiArabia]
        )
        
        // With custom theme
        PhoneNumberTextField(
            phoneNumber: .constant("512345678"),
            selectedCountry: .constant(.uae),
            theme: DesignTextFieldTheme(
                backgroundColor: .white,
                borderColor: .blue,
                borderWidth: 1
            )
        )
        
        // Disabled state
        PhoneNumberTextField(
            phoneNumber: .constant(""),
            selectedCountry: .constant(.egypt),
            disabled: true
        )
        
        // Without country code
        PhoneNumberTextField(
            phoneNumber: .constant(""),
            selectedCountry: .constant(.unitedStates),
            showCode: false
        )
    }
    .padding()
}
