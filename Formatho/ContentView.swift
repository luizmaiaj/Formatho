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
                
#if os(macOS)
                    .navigationSubtitle("Work Item Type")
#else
                    .navigationTitle("Work Item Type")
#endif
            case .recent:
                ActivityView(fetcher: fetcher, selectedWIT: $selectedWIT)
                    .navigationSplitViewColumnWidth(min: 250, ideal: 300)
#if os(macOS)
                    .navigationSubtitle("Activity")
#else
                    .navigationTitle("Activity")
#endif
            case .query:
                QueryHierarchyView(queriesFetcher: queriesFetcher, queryid: $queryID, copyToCB: $copyToCB, includeReport: $includeReport)
                    .navigationSplitViewColumnWidth(min: 250, ideal: 300)
#if os(macOS)
                    .navigationSubtitle("Query")
#else
                    .navigationTitle("Query")
#endif

            case .graph:
                GraphView(fetcher: fetcher)
#if os(macOS)
                    .navigationSubtitle("Graph")
#else
                    .navigationTitle("Graph")
#endif

            case .tree:
                TreeView(fetcher: fetcher)
#if os(macOS)
                    .navigationSubtitle("Tree")
#else
                    .navigationTitle("Tree")
#endif

            case .list:
                ListView(fetcher: fetcher)
#if os(macOS)
                    .navigationSubtitle("List")
#else
                    .navigationTitle("List")
#endif
            case .login, .none:
                LoginView(fetcher: fetcher)
#if os(macOS)
                    .navigationSubtitle("Login")
#else
                    .navigationTitle("Login")
#endif
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
