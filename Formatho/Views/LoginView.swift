//
//  LoginView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 25/9/22.
//

import SwiftUI

struct LoginView: View {
    
    @AppStorage("organisation") private var organisation: String = String()
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    
    var body: some View {
        Form {
            TextField("organisation", text: $organisation)
            
            TextField("email", text: $email)
            
            if #available(macOS 13.0, *) {
                TextField("PAT", text: $pat, axis: .vertical)
                    .lineLimit(2...5)
            } else {
                TextField("PAT", text: $pat)
            }
        }
        .frame(maxWidth: 300, minHeight: 30)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
