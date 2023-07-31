//
//  OptionalExt.swift
//  xos
//
//  Created by nick on 31/07/2023.

import Foundation

extension Optional where Wrapped == NSSet {
    // swiftlint:disable identifier_name
    func array<T: Hashable>(of: T.Type) -> [T] {
        if let set = self as? Set<T> {
            return Array(set)
        }
        return [T]()
    }
    // swiftlint:enable identifier_name
}
