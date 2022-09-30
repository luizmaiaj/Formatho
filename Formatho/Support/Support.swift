//
//  Support.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 30/9/22.
//

import SwiftUI

extension String {
    func toRTF() -> AttributedString {
                
        if let data = self.data(using: .unicode),
           let nsAttrString = try? NSMutableAttributedString(data: data,
                                                      options: [.documentType: NSAttributedString.DocumentType.html],
                                                      documentAttributes: nil) {
            
            nsAttrString.addAttribute(.font, value: Font.body, range: NSRange(location: 0, length: nsAttrString.length))
            
            return AttributedString(nsAttrString) // string to be displayed in Text()
        }
        
        return AttributedString("")
    }
}
