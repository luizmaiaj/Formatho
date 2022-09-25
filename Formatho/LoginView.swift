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
            
            TextField("PAT", text: $pat)
        }
        .frame(maxWidth: 300)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
