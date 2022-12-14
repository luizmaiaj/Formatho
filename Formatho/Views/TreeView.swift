//
//  TreeView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 7/10/22.
//

import SwiftUI

import Combine

struct TreeView: View {
    
    @AppStorage("organisation", store: UserDefaults(suiteName: APP_GROUP)) var organisation: String = String()
    @AppStorage("email", store: UserDefaults(suiteName: APP_GROUP)) var email: String = String()
    @AppStorage("pat", store: UserDefaults(suiteName: APP_GROUP)) var pat: String = String()
    @AppStorage("project", store: UserDefaults(suiteName: APP_GROUP)) var project: String = String()

    @ObservedObject var fetcher: Fetcher
    
    @State var witid: String = String("")
    
    func fetch() {
        
        self.fetcher.links(org: organisation, pat: pat, email: email, id: witid)
    }
    
    var body: some View {
        VStack {
            
            if self.fetcher.isLoading {
                
                Text("Fetching \(self.fetcher.statusMessage ?? "")...")
                
            } else {
                
                VStack {
                    HStack {
                        
                        TextField("WIT ID", text: $witid)
                            .frame(maxWidth: 125, alignment: .trailing)
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
                    
                    if !fetcher.nodes.isEmpty {
                        List {
                            OutlineGroup(fetcher.nodes, children: \.children) { item in
                                
                                witIcon(type: item.fields.SystemWorkItemType)
                                + Text(" \(item.description)")
                            }
                        }
                    }
                }
            }
#if os(iOS)
            Text(self.fetcher.errorMessage ?? "") // only on iOS
#endif
        }
    }
}

struct TreeView_Previews: PreviewProvider {
    static var previews: some View {
        TreeView(fetcher: Fetcher())
    }
}
