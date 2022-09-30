//
//  Support.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 30/9/22.
//

import Foundation
import AppKit

extension String {
    func toRTF() -> AttributedString {
        if let data = self.data(using: .unicode),
           var nsAttrString = try? NSMutableAttributedString(data: data,
                                                      options: [.documentType: NSAttributedString.DocumentType.html],
                                                      documentAttributes: nil) {
            
            return AttributedString(nsAttrString) // string to be displayed in Text()
        }
        
        return AttributedString("")
    }
}
