//
//  WeatherType.swift
//  WeatherApp(VKIntership)
//
//  Created by Denis Raiko on 21.07.24.
//

import Foundation

enum WeatherType: String, CaseIterable {
    case clear = "Clear"
    case rain = "Rain"
    case thunderstorm = "Thunderstorm"
    case fog = "Fog"
    case rainbow = "Rainbow"
    case moon = "Moon"
    
    var displayName: String {
            switch self {
            case .clear:
                return NSLocalizedString("Clear", comment: "Clear weather")
            case .rain:
                return NSLocalizedString("Rain", comment: "Rainy weather")
            case .thunderstorm:
                return NSLocalizedString("Thunderstorm", comment: "Thunderstorm weather")
            case .fog:
                return NSLocalizedString("Fog", comment: "Foggy weather")
            case .rainbow:
                return NSLocalizedString("Rainbow", comment: "Rainbow weather")
            case .moon:
                return NSLocalizedString("Moon", comment: "Moon weather")
            }
        }
}
