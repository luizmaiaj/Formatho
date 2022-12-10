//
//  ListView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 5/12/22.
//

import SwiftUI
import Combine

struct ListView: View {
    
    @AppStorage("organisation") private var organisation: String = String()
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    @AppStorage("project") private var project: String = String()
    
    @AppStorage("copyToCB") private var copyToCB: Bool = false
    @AppStorage("includeReport") private var includeReport: Bool = false
    
    @ObservedObject var fetcher: Fetcher
    
    @State var witid: String = String()
    @State var witList: [String] = [String]()
    
    func fetch() {
        fetcher.wits(org: organisation, pat: pat, email: email, ids: witList, project: project, cb: copyToCB, includeReport: includeReport)
    }
    
    func addToList() {
        if !witList.contains(witid) {
            
            witList.append(witid)
            
            witid = ""
        }
    }
    
    var body: some View {
        VStack {
            
            if fetcher.isLoading {
                
                Text("Fetching...")
                
            } else {
                
                HStack {
                    
                    VStack {
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
                                addToList()
                            }
                        
                        Button("Add to list", action: {
                            addToList()
                        })
                    }
                    
                    VStack {
                        
                        HStack {
                            Toggle("copy to clipboard", isOn: $copyToCB)
                            
                            Toggle("include report", isOn: $includeReport)
                        }
                        
                        List {
                            ForEach(witList, id: \.self) {
                                
                                Text("\($0)")
                            }
                        }
                        
                        Button("Get WITs", action: {
                            fetch()
                        })
                    }
                }
#if os(iOS)
                .padding([.top])
#endif
            }
            
#if os(iOS)
            Text(self.fetcher.errorMessage ?? "") // only on iOS
#endif
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(fetcher: Fetcher())
    }
}
