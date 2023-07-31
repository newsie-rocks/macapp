//
//  AppError.swift
//  macapp
//
//  Created by nick on 30/07/2023.
//

import Foundation

/// Generic custom error
enum AppError: Error {
    case generic(String)
    case invalidParam(String)
}

// Assign a localised description to each type of error.
extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .generic(let message):
            return message
        case .invalidParam(let message):
            return message
        }
    }
}
