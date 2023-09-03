//
//  Config.swift
//  formatho
//
//  Created by Luiz Carlos Maia Junior on 3/9/23.
//

import SwiftUI

struct ConfigView: View {
    
    @AppStorage("copyToCB") private var copyToCB: Bool = false
    @AppStorage("includeReport") private var includeReport: Bool = false
    @AppStorage("sortPriority") private var sortPriority: Bool = false

    var body: some View {
        Form {
            Section("Configuration") {
                Toggle("copy results to pasteboard", isOn: $copyToCB)
                
                Toggle("include report field", isOn: $includeReport)
            }
            
            Section("List") {
                Toggle("sort by priority", isOn: $sortPriority)
            }
        }
    }
}

#Preview {
    ConfigView()
}
