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
    case login = 3
}

struct ContentView: View {
    
    @StateObject var fetcher: Fetcher = Fetcher()
    
    @State private var selection: Tab = Tab.wit
    
    var body: some View {
        
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
            
            LoginView()
                .tabItem {
                    Text("Login")
                }
                .tag(Tab.login)
        }
        .frame(minWidth: 500, maxWidth: 1000, minHeight: 300, maxHeight: 1000)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
