//
//  QueryHierarchyView.swift
//  formatho
//
//  Created by Luiz Carlos Maia Junior on 3/9/23.
//

import SwiftUI

struct QueryHierarchyView: View {
    
    @ObservedObject var queriesFetcher: Fetcher
    
    @Binding var queryid: String
    
    var body: some View {
        
        Group {
            if queriesFetcher.isFetchingQuery {
                
                FetchingView()
                
            } else {
                
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
            }
        }
        .navigationTitle("Queries")
    }
}

//#Preview {
//    QueryHierarchyView()
//}
