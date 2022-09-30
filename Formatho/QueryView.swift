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
                    
                    let columns = [GridItem(.fixed(20)),
                                   GridItem(.flexible(minimum: 50, maximum: 110)),
                                   GridItem(.flexible(minimum: 200, maximum: 400)),
                                   GridItem(.fixed(110)),
                                   GridItem(.flexible(minimum: 0, maximum: 400))]
                    
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .leading) {
                            ForEach(fetcher.wits, id: \.self) { value in
                                Text("P\(value.fields.MicrosoftVSTSCommonPriority)")
                                Text(value.fields.SystemWorkItemType)
                                Text(value.fields.SystemTitle)
                                Text("[SCOPE-\(String(format: "%d", value.id))]")
                                Text(value.fields.CustomReport)
                            }
                        }
                    }
                    .frame(minHeight: 30)
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
