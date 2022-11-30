//
//  Extensions.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 13/10/22.
//

import SwiftUI

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

func witIcon(type: String) -> Text {
    
    print(type)
    
    switch type {
    case workItemType.epic.rawValue:
        return Text(Image(systemName: "crown.fill")).foregroundColor(.orange)
        
    case workItemType.userStory.rawValue:
        return Text(Image(systemName: "book.fill")).foregroundColor(.blue)
        
    case workItemType.feature.rawValue:
        return Text(Image(systemName: "trophy.fill")).foregroundColor(.purple)
        
    case workItemType.issue.rawValue, workItemType.impediment.rawValue:
        return Text(Image(systemName: "cone.fill")).foregroundColor(.purple)
        
    case workItemType.pbi.rawValue:
        return Text(Image(systemName: "doc.plaintext.fill")).foregroundColor(.blue)
        
    case workItemType.bug.rawValue:
        return Text(Image(systemName: "ladybug.fill")).foregroundColor(.red)
        
    case workItemType.task.rawValue:
        return Text(Image(systemName: "checkmark.rectangle.portrait.fill")).foregroundColor(.yellow)
        
    default:
        return Text(Image(systemName: "questionmark.square.dashed")).foregroundColor(.red)
    }
}
