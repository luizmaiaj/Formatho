//
//  QueryView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 29/9/22.
//

import SwiftUI

struct QueryView: View {
    
    @AppStorage("copyToCB") private var copyToCB: Bool = false
    @AppStorage("includeReport") private var includeReport: Bool = false
    
    @ObservedObject var fetcher: Fetcher
    
    @State var queryID: String = ""
    
    private func fetch() {
        self.fetcher.query(queryid: queryID, cb: copyToCB, addReport: includeReport)
    }
    
    private func queryWidth(width: CGFloat) -> CGFloat {
        
        var newWidth = width - QUERY_TREE_WIDTH
        
        if newWidth < QUERY_TREE_WIDTH { newWidth = QUERY_TREE_WIDTH }
        
        return newWidth
    }
    
    var body: some View {
        
        GeometryReader { g in
            
            HStack {
                
                VStack {
                    
                    QueryHierarchyView(queriesFetcher: fetcher.copy(), queryid: $queryID)
                }
                .frame(width: QUERY_TREE_WIDTH, height: g.size.height)
                
                VStack {
                    
                    if fetcher.isLoading {
                        
                        Text("Fetching \(fetcher.statusMessage ?? "")...")
                        
                    } else {
                        
                        HStack {
                            Toggle("copy to clipboard", isOn: $copyToCB)
                            
                            Toggle("include report", isOn: $includeReport)
                        }
                        
                        HStack {
                            
                            TextField("QUERY ID", text: $queryID)
                                .frame(alignment: .trailing)
                                .frame(maxWidth: 350)
                                .onSubmit {
                                    fetch()
                                }
                            
                            Button("Query", action: {
                                fetch()
                            })
                        }
                        
                        if !fetcher.wits.isEmpty {
                            
                            WitTableView(wits: self.fetcher.wits, fetcher: fetcher)
                        }
                    }
                }
                .padding([.trailing, .top])
                .frame(width: queryWidth(width: g.size.width), height: g.size.height)
                .onChange(of: queryID) { newValue in
                    
                    fetch()
                }
            }
        }
    }
}

struct QueryHierarchyView: View {
    
    @StateObject var queriesFetcher: Fetcher
    
    @Binding var queryid: String
    
    private func fetch() {
        self.queriesFetcher.getQueries()
    }
    
    var body: some View {
        
        if queriesFetcher.isLoading {
            
            FetchingView()
            
        } else {
            
            Button("Refresh queries' list", action: {
                fetch()
            })
            
            HStack {
                
                List {
                    OutlineGroup(queriesFetcher.queries, children: \.children) { item in
                        
                        if !item.isFolder {
                            
                            Button("📄 \(item.description)", action: {
                                queryid = item.id
                            })
                            
                        } else {
                            Text("📂 \(item.description)")
                        }
                    }
                }
                .onAppear() {
                    
                    // if empty query if not empty user has to refresh
                    if queriesFetcher.queries.isEmpty {
                        fetch()
                    }
                }
            }
        }
    }
}

struct QueryView_Previews: PreviewProvider {
    static var previews: some View {
        QueryView(fetcher: Fetcher())
    }
}
