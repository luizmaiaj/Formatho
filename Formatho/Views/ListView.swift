//
//  ListView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 5/12/22.
//

import SwiftUI
import Combine

struct ListView: View {
    
    @AppStorage("copyToCB") private var copyToCB: Bool = false
    @AppStorage("includeReport") private var includeReport: Bool = false
    @AppStorage("sortPriority") private var sortPriority: Bool = false
    
    @ObservedObject var fetcher: Fetcher
    
    @State var witid: String = String()
    @State var witList: [String] = [String]()
    
    private func fetch() {
        fetcher.getWits(ids: witList, cb: copyToCB, includeReport: includeReport)
    }
    
    private func addItem() {
        if !witList.contains(witid) {
            
            witList.append(witid)
            
            witid = ""
        }
    }
    
    private func removeItem(at indexSet: IndexSet) {
        self.witList.remove(atOffsets: indexSet)
    }
    
    var body: some View {
        VStack {
            
            if fetcher.isLoading {
                
                FetchingView()
                
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
                                addItem()
                            }
                            .padding([.leading], 10)
                        
                        Button("Add to list", action: { addItem() })
                    }
                    
                    VStack {
                        
                        HStack {
                            Toggle("copy to clipboard", isOn: $copyToCB)
                            
                            Toggle("include report", isOn: $includeReport)
                            
                            Toggle("sort by priority", isOn: $sortPriority)
                        }
                        
                        List {
                            ForEach(Array(witList.enumerated()), id: \.element) { index, element in
                                
                                Text("\(element)")
                                    .contextMenu { // right click menu for MacOS
                                        Button(action: {
                                            self.witList.remove(atOffsets: [index])
                                        }){
                                            Text("Delete")
                                        }
                                    }
                            }
                            .onDelete(perform: self.removeItem) // swipe left action
                        }
                        
                        HStack {
                            Button("Clear list", action: { witList.removeAll() })
                            
                            Button("Get WITs", action: { fetch() })
                        }
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
