//
//  ContentView.swift
//  formathoPhone
//
//  Created by Luiz Carlos Maia Junior on 11/12/22.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("organisation", store: UserDefaults(suiteName: APP_GROUP)) var organisation: String = String()
    @AppStorage("email", store: UserDefaults(suiteName: APP_GROUP)) var email: String = String()
    @AppStorage("pat", store: UserDefaults(suiteName: APP_GROUP)) var pat: String = String()
    @AppStorage("project", store: UserDefaults(suiteName: APP_GROUP)) var project: String = String()
    
    @StateObject var fetcher: Fetcher = Fetcher()
    
    @State private var selection: Tab = Tab.wit
    
    init() {
        
        UITabBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        
        VStack {
            
            if (organisation.isEmpty || pat.isEmpty || email.isEmpty || project.isEmpty) && selection != Tab.login {
                
                Text("Please configure login")
                
                Button {
                    selection = Tab.login
                    
                } label: {
                    
                    HStack {
                        
                        Text("Login details")
                        
                        Image(systemName: "person.circle")
                            .font(.title2)
                    }
                }
                
            } else {
                
                TabView(selection: $selection) {
                    
                    LoginView(fetcher: fetcher)
                        .tabItem {
                            Text("Login")
                            
                            Image(systemName: "person.circle")
                                .font(.title2)
                        }
                        .tag(Tab.login)
                    
                    WitView(fetcher: fetcher)
                        .tabItem {
                            Text("WIT")
                            
                            Image(systemName: "crown.fill")
                                .font(.title2)
                        }
                        .tag(Tab.wit)
                    
                    ActivityView(fetcher: fetcher)
                        .tabItem {
                            Text("Activity")
                            
                            Image(systemName: "list.bullet")
                                .font(.title2)
                        }
                        .tag(Tab.recent)
                    
                    TreeView(fetcher: fetcher)
                        .tabItem {
                            Text("Tree")
                            
                            Image(systemName: "rectangle.3.group.fill")
                                .font(.title2)
                        }
                        .tag(Tab.tree)
                }
            }
        }
        .onAppear() {
            
            self.fetcher.initialise(org: organisation, email: email, pat: pat, project: project)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
