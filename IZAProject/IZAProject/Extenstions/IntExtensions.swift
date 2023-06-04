//
//  IntExtensions.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 27.05.2023.
//

import Foundation

extension Int {
    var pointsFormat: String {
        switch self {
        case 1_000_000...Int.max:
            return String(format: "%.1fM", Double(self) / 1_000_000)
        case 1_000...999_999:
            return String(format: "%.1fK", Double(self) / 1_000)
        default:
            return "\(self)"
        }
    }
    
    var durationFormat: String {
        switch self {
        case 60 ... 1439:
            return String(format: "%.1f\nh", Double(self) / 60)
        case 1440 ... Int.max:
            return String(format: "%.1f\nd", Double(self) / 1_440)
        default:
            return "\(self)\nmin"
        }
    }
    
    var durationFormatNormal: String{
        switch self {
        case 60 ... 1439:
            return String(format: "%.1f h", Double(self) / 60)
        case 1440 ... Int.max:
            return String(format: "%.1f d", Double(self) / 1_440)
        default:
            return "\(self) min"
        }
    }
    
    var duration: String {
        switch self {
        case 60 ... 1439:
            return String(format: "%.1f", Double(self) / 60)
        case 1440 ... Int.max:
            return String(format: "%.1f", Double(self) / 1_440)
        default:
            return "\(self)"
        }
    }
}
