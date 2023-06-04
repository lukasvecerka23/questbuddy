//
//  Frequency.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 31.05.2023.
//

import Foundation

enum Frequency: Int, CaseIterable {
    case daily = 0
    case weekly = 1
    case monthly = 2
    
    var stringValue: String {
        switch self {
        case .daily:
            return "Daily"
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        }
    }
}
