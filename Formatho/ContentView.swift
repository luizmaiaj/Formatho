//
//  ContentView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 11/9/22.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("organisation") private var organisation: String = String()
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    @AppStorage("project") private var project: String = String()
    
    @StateObject var fetcher: Fetcher = Fetcher()
    
    @State private var selection: Tab = Tab.wit
    
    func getW() -> CGFloat { // WIDTH
        switch selection {
        case Tab.wit:
            return 250
        default:
            return 400
        }
    }
    
    func getH() -> CGFloat { // HEIGHT
        switch selection {
        case Tab.wit:
            return 65
        default:
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
                    
                    ListView(fetcher: fetcher)
                        .tabItem {
                            Text("List")
                            
                            if #available(iOS 15.0, *) {
                                Image(systemName: "list.dash")
                                    .font(.title2)
                            }
                        }
                        .tag(Tab.list)
                    
                    TreeView(fetcher: fetcher)
                        .tabItem {
                            Text("Tree")
                            
                            if #available(iOS 15.0, *) {
                                Image(systemName: "rectangle.3.group.fill")
                                    .font(.title2)
                            }
                        }
                        .tag(Tab.tree)
                }
            }
            Text(self.fetcher.errorMessage ?? "") // only on macOS
        }
        .frame(minWidth: getW(), minHeight: getH())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
