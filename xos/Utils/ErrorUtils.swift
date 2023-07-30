//
//  ErrorUtils.swift
//  macapp
//
//  Created by nick on 30/07/2023.
//

import Foundation

/// Throws a specific error as a method
func throwError<T>(_ error: Error) throws -> T {
    throw error
}

/// Unwraps or throws and error
infix operator ?!: NilCoalescingPrecedence

/// Throws the right hand side error if the left hand side optional is `nil`.
func ?! <T>(value: T?, error: @autoclosure () -> Error) throws -> T {
    guard let value = value else {
        throw error()
    }
    return value
}
