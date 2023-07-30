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
