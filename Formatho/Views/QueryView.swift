//
//  QueryView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 29/9/22.
//

import SwiftUI

struct QueryView: View {
    
    @AppStorage("organisation") private var organisation: String = String()
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    @AppStorage("project") private var project: String = String()
    
    @AppStorage("queryid") private var queryid: String = String()
    
    @AppStorage("copyToCB") private var copyToCB: Bool = false
    @AppStorage("addReport") private var addReport: Bool = false
    
    @ObservedObject var fetcher: Fetcher
    
    private func fetchWits() {
        self.fetcher.query(org: organisation, pat: pat, email: email, queryid: queryid, project: project, cb: copyToCB, addReport: addReport)
    }
    
    private func fetchQueries() {
        self.fetcher.queries(org: organisation, pat: pat, email: email, project: project)
    }
    
    var body: some View {
        
        HStack {
            if fetcher.isLoading {
                
                Text("Fetching...")
                
            } else {
                
                VStack {
                    Button("Refresh queries' list", action: {
                        fetchQueries()
                    })
                    
                    HStack {
                        
                        List {
                            OutlineGroup(fetcher.queries, children: \.children) { item in
                                
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
                        .onAppear(){
                            
                            // if empty query if not empty user has to refresh
                            if fetcher.queries.isEmpty {
                                fetchQueries()
                            }
                        }
                    }
                }
                .padding()
                
                VStack {
                    HStack {
                        Toggle("copy to clipboard", isOn: $copyToCB)
                        
                        Toggle("add report", isOn: $addReport)
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
                .padding()
                
                Text(self.fetcher.errorMessage ?? "")
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
    
    let wits: [Wit]
    
    var body: some View {
        
        Table(wits) {
            TableColumn("Priority") { wit in
                Text("P" + String(format: "%d", wit.fields.MicrosoftVSTSCommonPriority))
            }
            TableColumn("Type", value: \.fields.SystemWorkItemType)
            TableColumn("Title", value: \.fields.SystemTitle)
            TableColumn("id") { wit in
                Text(String(format: "%d", wit.witID)) // removing reference
            }
            TableColumn("Report") { wit in
                Text(wit.fields.CustomReport.toRTF())
            }
        }
        .frame(minHeight: 30)
    }
}
