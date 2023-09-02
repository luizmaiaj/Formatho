//
//  TreeView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 7/10/22.
//

import SwiftUI

import Combine

struct TreeView: View {
    
    @ObservedObject var fetcher: Fetcher
    
    @State var witid: String = String("")
    
    func fetch() {
        
        self.fetcher.getWitLinks(id: Int(witid) ?? 0)
    }
    
    var body: some View {
        VStack {
            VStack {
                
                if self.fetcher.isFetchingWIT {
                    
                    FetchingView()
                    
                } else {
                    HStack {
                        
                        TextField("WIT ID", text: $witid)
                            .frame(maxWidth: 80, alignment: .trailing)
                            .onReceive(Just(witid)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue { witid = filtered }
                            }
                            .disableAutocorrection(true)
#if os(iOS)
                            .keyboardType(.numberPad)
#endif
                            .border(.secondary)
                            .onSubmit {
                                fetch()
                            }
                        
                        Button("Get WIT", action: {
                            fetch()
                        })
                    }
#if os(iOS)
                    .padding([.top])
#endif
                }
                
                if fetcher.root.witID != 0 {
                    
                    let reqURL: String = BASE_URL + fetcher.organisation + "/" + fetcher.project + "/_workitems/edit/"
                    
                    List {
                        OutlineGroup(fetcher.root, children: \.children) { item in
                            
                            if item.rel.rel == relation.pullRequest || item.rel.rel == relation.file {
                                witIcon(type: item.rel.rel.rawValue)
                                + Text(" \(item.description)")
                            } else {
                                
                                HStack(spacing: 0.0) {
                                    witIcon(type: item.fields.SystemWorkItemType)
                                    Link(" \(item.textWitID): ", destination: URL(string: "\(reqURL)\(item.textWitID)")!)
                                    Text(" \(item.description)")
                                }
                            }
                        }
                    }
                }
            }
#if os(iOS)
            Text(self.fetcher.statusMessage ?? "") // only on iOS
#endif
        }
    }
}

struct TreeView_Previews: PreviewProvider {
    static var previews: some View {
        TreeView(fetcher: Fetcher())
    }
}
