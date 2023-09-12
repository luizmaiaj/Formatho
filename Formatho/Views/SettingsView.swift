//
//  LoginView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 25/9/22.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("organisation", store: UserDefaults(suiteName: APP_GROUP)) var organisation: String = String()
    @AppStorage("email", store: UserDefaults(suiteName: APP_GROUP)) var email: String = String()
    @AppStorage("pat", store: UserDefaults(suiteName: APP_GROUP)) var pat: String = String()
    @AppStorage("project", store: UserDefaults(suiteName: APP_GROUP)) var project: String = String()
        
    @AppStorage("queryid") private var queryid: String = String() // to use the reset AppStorage
    
    @AppStorage("copyToCB") private var copyToCB: Bool = false
    @AppStorage("includeReport") private var includeReport: Bool = false
    @AppStorage("sortPriority") private var sortPriority: Bool = false

    
    @State private var connectionTested: Bool = false
    
    @ObservedObject var fetcher: Fetcher
    
    func fetch() {
        fetcher.getProjects(org: organisation, email: email, pat: pat)
    }
    
    func initProject() {
        
        if project.isEmpty {
            project = fetcher.projectNames.first ?? ""
        }
    }
    
    var body: some View {
        
        VStack {
            
            if fetcher.isFetchingWIT {
    
                FetchingView()
                
            } else {
                
                Form {
                    
                    Section("Login") {
                        LoginDetails(organisation: $organisation, email: $email, pat: $pat)
                        
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
                            
                            let _ = initProject()
                            
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
                    
                    Divider()
                        .padding()

                    Section("Configuration") {
                        Toggle("copy results to pasteboard", isOn: $copyToCB)
                        
                        Toggle("include report field", isOn: $includeReport)

                        Toggle("sort lists by priority", isOn: $sortPriority)
                    }
                }
            }
#if os(iOS)
            Text(self.fetcher.statusMessage ?? "") // only on iOS
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
        .onDisappear() {
            fetcher.setProject(project: project)
        }
#if !os(OSX)
        .scrollDismissesKeyboard(.interactively)
//        .onTapGesture {
//            hideKeyboard()
//        }
#endif
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(fetcher: Fetcher())
    }
}

struct LoginDetails: View {
    
    @Binding var organisation: String
    @Binding var email: String
    @Binding var pat: String
    
    var body: some View {
        
        Group {
            LoginField(name: "organisation", value: $organisation)
                .padding([.leading])
            
            LoginField(name: "email", value: $email)
            
            LoginField(name: "PAT", value: $pat)
                .lineLimit(2...5)
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
