//
//  ContentView.swift
//  formathoPhone
//
//  Created by Luiz Carlos Maia Junior on 11/12/22.
//

import SwiftUI

struct ContentView: View {
    
    //@AppStorage("organisation") private var organisation: String = String()
    @AppStorage("organisation", store: UserDefaults(suiteName: "group.io.red8.formatho")) private var organisation: String = String()
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    @AppStorage("project") private var project: String = String()
    
    @StateObject var fetcher: Fetcher = Fetcher()
    
    @State private var selection: Tab = Tab.wit
    
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
