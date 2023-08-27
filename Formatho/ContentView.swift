//
//  ContentView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 11/9/22.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("organisation", store: UserDefaults(suiteName: APP_GROUP)) var organisation: String = String()
    @AppStorage("email", store: UserDefaults(suiteName: APP_GROUP)) var email: String = String()
    @AppStorage("pat", store: UserDefaults(suiteName: APP_GROUP)) var pat: String = String()
    @AppStorage("project", store: UserDefaults(suiteName: APP_GROUP)) var project: String = String()
    
    @StateObject var fetcher: Fetcher = Fetcher()
    
    @State private var selection: Tab = Tab.wit
    
    var body: some View {
                
        NavigationSplitView {
            
            SideBarView(selection: $selection)
            
        } detail: {
            
            switch selection {
                
            case .login:
                LoginView(fetcher: fetcher)
            case .wit:
                WitView(fetcher: fetcher)
            case .recent:
                ActivityView(fetcher: fetcher)
            case .query:
                QueryView(fetcher: fetcher)
            case .graph:
                GraphView(fetcher: fetcher)
            case .tree:
                TreeView(fetcher: fetcher)
            case .list:
                ListView(fetcher: fetcher)
            }
            
            //Text(self.fetcher.statusMessage ?? "") // only on macOS
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
