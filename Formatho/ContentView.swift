//
//  ContentView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 11/9/22.
//

import SwiftUI

enum Tab: Int {
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
    
    @StateObject var fetcher: Fetcher = Fetcher()
    
    @State var isPresentedLogin = false
    
    @State private var selection: Tab = Tab.wit
    
    @State var tree: Tree<Unique<Int>> = binaryTree.map(Unique.init)
    
    var body: some View {
        
        VStack {
            
            if isPresentedLogin {
                
                LoginView()
                
            } else {
                TabView(selection: $selection) {
                    
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
                    
                    GraphView(fetcher: fetcher)
                        .tabItem {
                            Text("Graph")
                        }
                        .tag(Tab.graph)
                    
                    TreeView()
                        .tabItem {
                            Text("Tree")
                        }
                        .tag(Tab.tree)
                    
                    DiagramSimple(tree: tree, node: { value in
                        Text("\(value.value)")
                            .modifier(RoundedCircleStyle())
                    })
                        .tabItem {
                            Text("Diagram")
                        }
                        .tag(Tab.test)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                
                Button {
                    isPresentedLogin.toggle()
                } label: {
                    HStack {
                        
                        if email.isEmpty {
                            Text("Login details")
                        } else {
                            Text(email)
                        }
                        
                        Image(systemName: "person.circle")
                            .font(.title2)
                    }
                }
            }
        }
        .frame(minWidth: 250, idealWidth: 500, maxWidth: 1000, minHeight: 100, maxHeight: 1000)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
