//
//  ContentView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 11/9/22.
//

import SwiftUI

enum Tab: Int {
    case login = 0
    case wit = 1
    case recent = 2
    case query = 3
    case graph = 4
    case tree = 5
    case test = 6
}

struct ContentView: View {
    
    @AppStorage("organisation") private var organisation: String = String()
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
                    
#if os(OSX)
                    LoginView(fetcher: fetcher)
                        .tabItem {
                            Text("Login")
                        }
                        .tag(Tab.login)
                    
                    WitView(fetcher: fetcher)
                        .tabItem {
                            Text("WIT")
                        }
                        .tag(Tab.wit)
                    
                    ActivityView(fetcher: fetcher)
                        .tabItem {
                            Text("Activity")
                        }
                        .tag(Tab.recent)
                    
                    QueryView(fetcher: fetcher)
                        .tabItem {
                            Text("Query")
                        }
                        .tag(Tab.query)
                    
                    if #available(macOS 13.0, *) {
                        GraphView(fetcher: fetcher)
                            .tabItem {
                                Text("Graph")
                            }
                            .tag(Tab.graph)
                    }
                    
                    TreeView()
                        .tabItem {
                            Text("Tree")
                        }
                        .tag(Tab.tree)
                    
#else
                    WitTab(fetcher: fetcher)
                        .tabItem {
                            Text("WIT")
                        }
                        .tag(Tab.wit)
#endif
                }
            }
        }
        .frame(minWidth: 250, idealWidth: 500)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
