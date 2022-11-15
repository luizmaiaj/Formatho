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
    
    @AppStorage("queryid") private var queryid: String = String() //214f0278-10d4-46ba-b841-ec28dc500aec
    
    @AppStorage("copyToCB") private var copyToCB: Bool = false
    @AppStorage("addReport") private var addReport: Bool = false
    
    @ObservedObject var fetcher: Fetcher
    
    func fetch() {
        fetcher.query(org: organisation, pat: pat, email: email, queryid: queryid, project: project, cb: copyToCB, addReport: addReport)
    }
    
    var body: some View {
        VStack {
            
            if fetcher.isLoading {
                
                Text("Fetching...")
                
            } else {
                
                HStack {
                    
                    List {
                        OutlineGroup(fetcher.queries, children: \.children) { item in
                            
                            if !item.isFolder {
                                
                                Button("\(item.description)", action: {
                                    queryid = item.id
                                    
                                    fetch()
                                })
                                
                            } else {
                                Text("\(item.description)")
                            }
                        }
                    }
                    .padding()
                    
                    VStack {
                        Form {
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
                                            fetch()
                                        }
                                    
                                    Button("Query", action: {
                                        fetch()
                                    })
                                }
                            }
                        }
                        
                        if !fetcher.wits.isEmpty {
                            
                            Table(fetcher.wits) {
                                TableColumn("Priority") { wit in
                                    Text("P" + String(format: "%d", wit.fields.MicrosoftVSTSCommonPriority))
                                }
                                TableColumn("Type", value: \.fields.SystemWorkItemType)
                                TableColumn("Title", value: \.fields.SystemTitle)
                                TableColumn("id") { wit in
                                    Text(String(format: "%d", wit.id)) // removing reference
                                }
                                TableColumn("Report") { wit in
                                    Text(wit.fields.CustomReport.toRTF())
                                }
                            }
                            .frame(minHeight: 30)
                        }
                    }
                    .padding()
                }
                
                Text(self.fetcher.errorMessage ?? "")
            }
        }
        .onAppear(){
            self.fetcher.queries(org: organisation, pat: pat, email: email, project: project)
        }
    }
}

struct QueryView_Previews: PreviewProvider {
    static var previews: some View {
        QueryView(fetcher: Fetcher())
    }
}
