//
//  QueryView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 29/9/22.
//

import SwiftUI

struct QueryView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("copyToCB") private var copyToCB: Bool = false
    @AppStorage("includeReport") private var includeReport: Bool = false
    
    @ObservedObject var fetcher: Fetcher
    
    @State var queryID: String = ""
    
    @State var queryWidth: Double = QUERY_MIN_WIDTH
    @State var newWidth: CGFloat = QUERY_MIN_WIDTH
    
    private func fetch() {
        self.fetcher.query(queryid: queryID, cb: copyToCB, addReport: includeReport)
    }
        
    var body: some View {
        
        GeometryReader { g in
            
            HStack {
                
                QueryHierarchyView(queriesFetcher: fetcher.copy(), queryid: $queryID)
                    .frame(width: queryWidth, height: g.size.height)

                Divider()
                    .fixedSize(horizontal: false, vertical: false)
                    .overlay(colorScheme == .dark ? .white : .black)
                    .frame(width: 10, height: 50)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                
                                newWidth = queryWidth + gesture.translation.width
                            }
                            .onEnded({ value in
                                if newWidth <= QUERY_MIN_WIDTH {
                                    
                                    queryWidth = QUERY_MIN_WIDTH
                                    
                                } else if newWidth >= (g.size.width / 2) {
                                    
                                    queryWidth = g.size.width / 2
                                } else {
                                    
                                    queryWidth = newWidth
                                }
                            })
                    )
                
                VStack {
                    
                    if fetcher.isLoading {
                        
                        HStack {
                            FetchingView()
                        }
                        
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
                .frame(width: g.size.width - queryWidth, height: g.size.height)
                .onChange(of: queryID) { newValue in
                    
                    fetch()
                }
            }
            .navigationTitle("Queries")
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
            
            VStack {
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
}

struct QueryView_Previews: PreviewProvider {
    static var previews: some View {
        QueryView(fetcher: Fetcher())
    }
}
