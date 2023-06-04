//
//  TimeOfDay.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 31.05.2023.
//

import Foundation

enum TimeOfDay: Int, CaseIterable {
    case allday = 0
    case morning = 1
    case afternoon = 2
    case evening = 3
    
    var stringValue: String {
        switch self {
        case .morning:
            return "Morning"
        case .afternoon:
            return "Afternoon"
        case .evening:
            return "Evening"
        case .allday:
            return "All Day"
        }
    }
}
