//
//  LoginView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 25/9/22.
//

import SwiftUI

struct LoginView: View {
    
    //@AppStorage("organisation") private var organisation: String = String()
    @AppStorage("organisation", store: UserDefaults(suiteName: "group.io.red8.formatho")) private var organisation: String = String()
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
        
        VStack {
            
            if fetcher.isLoading {
                
                Text("Fetching...")
                
            } else {
                
                LoginDetails()
                
                HStack {
                    Button("Get project list", action: {
                        fetch()
                    })
                    
                    if self.connectionTested == false {
                        
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
                
                if fetcher.projects.count > 0 {
                    
                    Picker("Project", selection: $project) {
                        
                        ForEach(fetcher.projectNames, id: \.self) {
                            Text($0)
                        }
                    }
#if os(OSX)
                    .frame(maxWidth: 300)
#endif
                }
            }
#if os(iOS)
            Text(self.fetcher.errorMessage ?? "") // only on iOS
#endif
        }
        .onAppear() {
            
            if !organisation.isEmpty && !pat.isEmpty && !email.isEmpty {
                
                fetch()
                
            } else if organisation.isEmpty || pat.isEmpty || email.isEmpty { // if information is missing clear project list
                
                self.project = ""
                self.queryid = ""
                
                fetcher.projects.removeAll()
            }
            
            self.connectionTested = true
        }
#if !os(OSX)
        .onTapGesture {
            hideKeyboard()
        }
#endif
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(fetcher: Fetcher())
    }
}

struct LoginDetails: View {
    
    //@AppStorage("organisation") private var organisation: String = String()
    @AppStorage("organisation", store: UserDefaults(suiteName: "group.io.red8.formatho")) private var organisation: String = String()
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    
    var body: some View {
        
        Form {
            
            LoginField(name: "organisation", value: $organisation)
            
            LoginField(name: "email", value: $email)
            
            if #available(macOS 13.0, *) {
                LoginField(name: "PAT", value: $pat)
                    .lineLimit(2...5)
            } else {
                LoginField(name: "PAT", value: $pat)
            }
        }
#if os(OSX)
        .frame(maxWidth: 300)
#endif
    }
}

struct LoginField: View {
    let name: String
    
    @Binding var value: String
    
    var body: some View {
        
        TextField(name, text: $value)
            .disableAutocorrection(true)
#if os(iOS)
            .textInputAutocapitalization(.never)
#endif
    }
}
