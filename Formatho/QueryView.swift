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
    
    @AppStorage("queryid") private var queryid: String = String() //214f0278-10d4-46ba-b841-ec28dc500aec
    
    @ObservedObject var fetcher: Fetcher
    
    var body: some View {
        VStack {
            
            if fetcher.isLoading {
                
                Text("Fetching...")
                
            } else {
                
                Form {
                    HStack {
                        
                        TextField("QUERY ID", text: $queryid)
                            .frame(alignment: .trailing)
                            .frame(maxWidth: 125)
                            .onSubmit {
                                fetcher.query(org: organisation, pat: pat, email: email, queryid: queryid)
                            }
                        
                        Button("Query", action: {
                            fetcher.query(org: organisation, pat: pat, email: email, queryid: queryid)
                        })
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
                            Text("[SCOPE-\(String(format: "%d", wit.id))]")
                        }
                        TableColumn("Report") { wit in
                            Text(wit.fields.CustomReport.toRTF())
                        }
                    }
                }
                
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
