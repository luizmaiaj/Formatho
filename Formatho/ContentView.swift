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
    @State private var selectedWIT: Activity.ID?
    
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
                    .navigationSplitViewColumnWidth(min: 150, ideal: 200)
                    .navigationSubtitle("Work Item Type")
            case .recent:
                ActivityView(fetcher: fetcher, selectedWIT: $selectedWIT)
                    .navigationSplitViewColumnWidth(min: 250, ideal: 300)
                    .navigationSubtitle("Activity")
            case .query:
                QueryHierarchyView(queriesFetcher: queriesFetcher, queryid: $queryID, copyToCB: $copyToCB, includeReport: $includeReport)
                    .navigationSplitViewColumnWidth(min: 250, ideal: 300)
                    .navigationSubtitle("Query")
            case .graph:
                GraphView(fetcher: fetcher)
                    .navigationSubtitle("Graph")
            case .tree:
                TreeView(fetcher: fetcher)
                    .navigationSubtitle("Tree")
            case .list:
                ListView(fetcher: fetcher)
                    .navigationSubtitle("List")
            case .login, .none:
                LoginView(fetcher: fetcher)
                    .navigationSubtitle("Login")
            }
            
            //Text(self.fetcher.statusMessage ?? "") // only on macOS
        } detail: {
            switch selection {
                
            case .wit:
                if !fetcher.wits.isEmpty {
                    
                    WITDetailView(wit: $fetcher.wit, fetcher: fetcher)
                }
            case .recent:
                if !fetcher.wits.isEmpty {
                    WITDetailView(wit: $fetcher.wit, fetcher: fetcher)
                } else {
                    Text("Please select a WIT")
                        .navigationSplitViewColumnWidth(min: 100, ideal: 200)
                }
            case .query:
                if queryID != "" && !fetcher.wits.isEmpty {
                    
                    WitTableView(wits: self.fetcher.wits, fetcher: fetcher)
                    
                } else {
                    
                    if fetcher.isFetchingWIT {
                        
                        FetchingView()
                    } else {
                        
                        Text("Please select a query")
                    }
                }
            case .login, .graph, .tree, .list, nil:
                Text("Hidden")
                    .navigationSplitViewColumnWidth(0)
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
        .onChange(of: selectedWIT) { newValue in
            
            guard let selectedEntry = fetcher.activities.first(where: { entry in
                entry.id == newValue
            }) else {
                return
            }
            
            // now search for the WIT to display
            fetcher.getWit(witid: String(selectedEntry.activityID))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
