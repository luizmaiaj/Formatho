//
//  QueryView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 29/9/22.
//

import SwiftUI

struct QueryView: View {
    
    //@AppStorage("organisation") private var organisation: String = String()
    @AppStorage("organisation", store: UserDefaults(suiteName: "group.io.red8.formatho")) private var organisation: String = String()
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    @AppStorage("project") private var project: String = String()
    
    @AppStorage("queryid") private var queryid: String = String()
    
    @AppStorage("copyToCB") private var copyToCB: Bool = false
    @AppStorage("includeReport") private var includeReport: Bool = false
    
    @ObservedObject var fetcher: Fetcher
    @StateObject var qFetcher: Fetcher = Fetcher()
    
    private func fetchWits() {
        self.fetcher.query(org: organisation, pat: pat, email: email, queryid: queryid, project: project, cb: copyToCB, addReport: includeReport)
    }
    
    private func fetchQueries() {
        self.qFetcher.queries(org: organisation, pat: pat, email: email, project: project)
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
                        
                        Text("Fetching \(qFetcher.statusMessage ?? "")...")
                        
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
                            
                            WitTable(wits: self.fetcher.wits)
                        }
                    }
                }
                .padding([.trailing, .top])
                .frame(width: queryWidth(width: g.size.width), height: g.size.height)
            }
        }
    }
}

struct QueryView_Previews: PreviewProvider {
    static var previews: some View {
        QueryView(fetcher: Fetcher())
    }
}

struct WitTable: View {
    
    @State var wits: [Wit]
    
    @State private var sortOrder = [KeyPathComparator(\Wit.id)]
    
    var body: some View {
        
        Table(wits, sortOrder: $sortOrder) {
            TableColumn("Priority", value: \.fields.textPriority)
                .width(max: 30)
            
            TableColumn("Type") { wit in
                witIcon(type: wit.fields.SystemWorkItemType)
            }
            .width(max: 30)
            
            TableColumn("Title", value: \.fields.SystemTitle)
            
            TableColumn("id", value: \.textWitID)
                .width(max: 50)
            
            TableColumn("Report") { wit in
                Text(wit.fields.CustomReport.toRTF())
            }
        }
        .onChange(of: sortOrder) {
            
            wits.sort(using: $0)
        }
    }
}
