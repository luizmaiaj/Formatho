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
    
    @AppStorage("copyToCB") private var copyToCB: Bool = false
    @AppStorage("includeReport") private var includeReport: Bool = false
    
    @StateObject var fetcher: Fetcher = Fetcher()
    @StateObject var queriesFetcher: Fetcher = Fetcher()
    
    @State private var selection: Tab? = Tab.wit
    @State private var queryID: String = ""
    
    private func fetch() {
        self.fetcher.query(queryid: queryID, cb: copyToCB, addReport: includeReport)
    }
    
    var body: some View {
                
        NavigationSplitView {
            
            SideBarView(selection: $selection, queriesFetcher: queriesFetcher)
            
        } content: {
            
            switch selection {
                
            case .wit:
                WitView(fetcher: fetcher)
            case .recent:
                ActivityView(fetcher: fetcher)
            case .query:
                QueryHierarchyView(queriesFetcher: queriesFetcher, queryid: $queryID, copyToCB: $copyToCB, includeReport: $includeReport)
            case .graph:
                GraphView(fetcher: fetcher)
            case .tree:
                TreeView(fetcher: fetcher)
            case .list:
                ListView(fetcher: fetcher)
            case .login, .none:
                LoginView(fetcher: fetcher)
            }
            
            //Text(self.fetcher.statusMessage ?? "") // only on macOS
        } detail: {
            switch selection {
            case .login:
                Text("Testing")
            case .wit:
                Text("Testing")
            case .recent:
                Text("Testing")
            case .query:
                if queryID != "" && !fetcher.wits.isEmpty {
                    
                    WitTableView(wits: self.fetcher.wits, fetcher: fetcher)
                    
                } else {
                    Text("Please select a query")
                }
            case .graph:
                Text("Testing")
            case .tree:
                Text("Testing")
            case .list:
                Text("Testing")
            case nil:
                Text("Testing")
            }
        }
        .onAppear() {
            
            self.fetcher.initialise(org: organisation, email: email, pat: pat, project: project)
            
            if self.queriesFetcher.queries.isEmpty {
                
                self.queriesFetcher.initialise(org: organisation, email: email, pat: pat, project: project)
                
                self.queriesFetcher.getQueries()
            }
        }
        .onChange(of: queryID) { newValue in
            
            fetch()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
