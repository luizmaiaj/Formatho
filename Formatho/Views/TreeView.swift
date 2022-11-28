//
//  TreeView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 7/10/22.
//

import SwiftUI

import Combine

struct TreeView: View {
    
    @AppStorage("organisation") private var organisation: String = String()
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    
    @StateObject var fetcher: Fetcher = Fetcher()
    
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
                    Form {
                        HStack {
                            
                            TextField("WIT ID", text: $witid)
                                .frame(maxWidth: 125, alignment: .trailing)
                                .onReceive(Just(witid)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue { witid = filtered }
                                }
                                .onSubmit {
                                    fetch()
                                }
                            
                            Button("Get WIT", action: {
                                fetch()
                            })
                        }
                    }
                    
                    List {
                        OutlineGroup(fetcher.nodes, children: \.children) { item in
                            
                            witIcon(type: item.fields.SystemWorkItemType)
                            + Text(" \(item.description)")
                        }
                    }
                    .padding()
                }
                
                Text(self.fetcher.errorMessage ?? "")
            }
        }
    }
}

struct TreeView_Previews: PreviewProvider {
    static var previews: some View {
        TreeView()
    }
}
