//
//  Extensions.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 13/10/22.
//

import Foundation

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

func getWit(url: String) -> String {
    
    let result = url.trimmingCharacters(in: .decimalDigits)
    
    if result.hasSuffix("/") {
        
        return String(url.dropFirst(result.count))
    }
    else {
        return ""
    }
}

func getWitNumber(url: String) -> Int {
    
    return Int(getWit(url: url)) ?? 0
}
