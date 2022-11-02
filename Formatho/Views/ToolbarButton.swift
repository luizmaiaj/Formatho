//
//  ToolbarButton.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 2/11/22.
//

import SwiftUI

struct ToolbarButton: View {
    let systemName: String
    let email: String

    @Binding var value: Bool

    var body: some View {
        Button {
            self.value.toggle()
        } label: {
            
            HStack {
                
                if email.isEmpty {
                    Text("Login details")
                } else {
                    Text(email)
                }
                
                Image(systemName: self.systemName)
                    .font(.title2)
            }
        }
    }
}

struct ToolbarButton_Previews: PreviewProvider {
    @State static var value = false

    static var previews: some View {
        ToolbarButton(systemName: "gearshape", email: "homer@fox.com", value: $value)
    }
}
