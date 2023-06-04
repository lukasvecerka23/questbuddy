//
//  StringExtensions.swift
//  IZAProject
//
//  Created by Lukáš Večerka on 31.05.2023.
//

import Foundation

extension String {
    // Email validation
    var isEmailValid: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    // Password validation
    var isPasswordValid: Bool {
        return self.count >= 6
    }
}
