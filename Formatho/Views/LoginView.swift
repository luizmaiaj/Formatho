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
    @AppStorage("queryid") private var queryid: String = String() // to use the reset AppStorage
    
    @State private var connectionTested: Bool = false
    
    @ObservedObject var fetcher: Fetcher
    
    func fetch() {
        fetcher.projects(org: organisation, pat: pat, email: email)
    }
    
    var body: some View {
        Form {
            TextField("organisation", text: $organisation)
                .disableAutocorrection(true)
            
            TextField("email", text: $email)
                .disableAutocorrection(true)
            
            if #available(macOS 13.0, *) {
                TextField("PAT", text: $pat, axis: .vertical)
                    .lineLimit(2...5)
                    .disableAutocorrection(true)
            } else {
                TextField("PAT", text: $pat)
                    .disableAutocorrection(true)
            }
            
            if fetcher.isLoading {
                
                Text("Fetching...")
                    .padding()
                
            } else {
                
                HStack {
                    Button("Get project list", action: {
                        fetch()
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
            
#if DEBUG
            if DEBUG_BUTTON {
                Button("Reset AppStorage", action: {
                    organisation = String("")
                    email = String("")
                    pat = String("")
                    project = String("")
                    queryid = String("")
                    
                    fetcher.projects.removeAll()
                })
                .padding()
            }
#endif
            
            if DEBUG_INFO {
                let _ = print(project)
            }
            
            if fetcher.projects.count > 0 {
                
                Picker("Project", selection: $project) {
                    
                    ForEach(fetcher.projectNames, id: \.self) {
                        Text($0)
                    }
                }
            } else {
                
                Text(self.fetcher.errorMessage ?? "")
            }
        }
#if os(OSX)
        .frame(maxWidth: 300, minHeight: 30)
#endif
        .onAppear() {
            
            if !organisation.isEmpty && !pat.isEmpty && !email.isEmpty {
                
                fetch()
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
