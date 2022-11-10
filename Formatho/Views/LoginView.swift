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
    
    @AppStorage("project") private var project: String = String()
    @State private var connectionTested: Bool = false
    
    @ObservedObject var fetcher: Fetcher
    
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
            
            if fetcher.isLoading {
                
                Text("Fetching...")
                    .padding()
                
            } else {
                
                HStack {
                    Button("Get project list", action: {
                        fetcher.projects(org: organisation, pat: pat, email: email)
                    })
                    .padding()
                    
                    if connectionTested == false {
                        
                        Text(Image(systemName: "checkmark.circle.badge.questionmark.fill"))
                            .foregroundColor(.yellow)
                            .fontWeight(.heavy)
                        
                    } else if fetcher.projects.count > 0 {
                        
                        Text(Image(systemName: "checkmark.circle.fill"))
                            .foregroundColor(.green)
                            .fontWeight(.heavy)
                        
                    } else {
                        
                        Text(Image(systemName: "checkmark.circle.badge.xmark.fill"))
                            .foregroundColor(.red)
                            .fontWeight(.heavy)
                    }
                }
            }
            
            Picker("Project", selection: $project) {
                ForEach(fetcher.projects) { project in
                    Text(project.name)
                }
            }
        }
        .frame(maxWidth: 300, minHeight: 30)
        .onAppear() {
            
            if !organisation.isEmpty && !pat.isEmpty && !email.isEmpty {
                
                fetcher.projects(org: organisation, pat: pat, email: email)
            }
            
            connectionTested = true
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(fetcher: Fetcher())
    }
}
