//
//  QueryView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 29/9/22.
//

import SwiftUI

struct QueryView: View {
    
    @AppStorage("queryid") private var queryid: String = String()
    
    @AppStorage("copyToCB") private var copyToCB: Bool = false
    @AppStorage("includeReport") private var includeReport: Bool = false
    
    @ObservedObject var fetcher: Fetcher
    @StateObject var qFetcher: Fetcher = Fetcher()
    
    private func fetchWits() {
        self.fetcher.query(queryid: queryid, cb: copyToCB, addReport: includeReport)
    }
    
    private func fetchQueries() {
        self.qFetcher.getQueries()
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
                    
                    if qFetcher.isLoading {
                        
                        FetchingView()
                        
                    } else {
                        
                        Button("Refresh queries' list", action: {
                            fetchQueries()
                        })
                        
                        HStack {
                            
                            List {
                                OutlineGroup(qFetcher.queries, children: \.children) { item in
                                    
                                    if !item.isFolder {
                                        
                                        Button("📄 \(item.description)", action: {
                                            queryid = item.id
                                            
                                            fetchWits()
                                        })
                                        
                                    } else {
                                        Text("📂 \(item.description)")
                                    }
                                }
                            }
                            .onAppear() {
                                
                                // if empty query if not empty user has to refresh
                                if qFetcher.queries.isEmpty {
                                    fetchQueries()
                                }
                            }
                        }
                    }
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
                            
                            TextField("QUERY ID", text: $queryid)
                                .frame(alignment: .trailing)
                                .frame(maxWidth: 350)
                                .onSubmit {
                                    fetchWits()
                                }
                            
                            Button("Query", action: {
                                fetchWits()
                            })
                        }
                        
                        if !fetcher.wits.isEmpty {
                            
                            WitTableView(wits: self.fetcher.wits, org: self.fetcher.organisation, email: self.fetcher.email, pat: self.fetcher.pat, project: self.fetcher.project)
                        }
                    }
                }
                .padding([.trailing, .top])
                .frame(width: queryWidth(width: g.size.width), height: g.size.height)
            }
            .onAppear() {
                
                self.qFetcher.initialise(org: self.fetcher.organisation, email: self.fetcher.email, pat: self.fetcher.pat, project: self.fetcher.project)
            }
        }
    }
}

struct QueryView_Previews: PreviewProvider {
    static var previews: some View {
        QueryView(fetcher: Fetcher())
    }
}
