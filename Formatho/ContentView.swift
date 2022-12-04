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
}

struct ContentView: View {
    
    @AppStorage("organisation") private var organisation: String = String()
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    @AppStorage("project") private var project: String = String()
    
    @StateObject var fetcher: Fetcher = Fetcher()
    
    @State private var selection: Tab = Tab.wit
    
    func getW() -> CGFloat { // WIDTH
        switch selection {
        case Tab.login:
            return 400
        case Tab.wit:
            return 250
        case Tab.recent:
            return 400
        case Tab.query:
            return 400
        case Tab.graph:
            return 400
        case Tab.tree:
            return 400
        }
    }
    
    func getH() -> CGFloat { // HEIGHT
        switch selection {
        case Tab.login:
            return 250
        case Tab.wit:
            return 65
        case Tab.recent:
            return 250
        case Tab.query:
            return 250
        case Tab.graph:
            return 250
        case Tab.tree:
            return 250
        }
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
                            
                            if #available(iOS 15.0, *) {
                                Image(systemName: "person.circle")
                                    .font(.title2)
                            }
                        }
                        .tag(Tab.login)
                    
                    WitView(fetcher: fetcher)
                        .tabItem {
                            Text("WIT")

                            if #available(iOS 15.0, *) {
                                Image(systemName: "crown.fill")
                                    .font(.title2)
                            }
                        }
                        .tag(Tab.wit)
                    
#if os(OSX)
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
#endif
                    
                    TreeView(fetcher: fetcher)
                        .tabItem {
                            Text("Tree")
                            
                            if #available(iOS 15.0, *) {
                                Image(systemName: "tree")
                                    .font(.title2)
                            }
                        }
                        .tag(Tab.tree)
                    
                }
            }
            
            Text(self.fetcher.errorMessage ?? "")
        }
        .frame(minWidth: getW(), minHeight: getH())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
