//
//  WitView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 25/9/22.
//

import SwiftUI

import Combine

struct WitView: View {
    
    @ObservedObject var fetcher: Fetcher
    
    @State var witid: String = String()
    
    func fetch() {
        fetcher.getWit(witid: witid)
    }
    
    var body: some View {
        VStack {
            
            if fetcher.isLoading {
                
                FetchingView()
                
            } else {
                
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
                
                if !fetcher.wits.isEmpty {
                    
                    ScrollView {
                        HStack {
                            if !fetcher.wit.fields.CustomCORequestor.isEmpty {
                                Text("CO: \(fetcher.wit.fields.CustomCORequestor)")
                            }
                            
                            Text("Area: \(fetcher.wit.fields.SystemAreaPath)")
                        }
                        .padding([.bottom], 10)
                        
                        HStack {
                            Text("Last change: \(fetcher.wit.fields.SystemChangedDate.formatted())")
                            
                            Text("State: \(fetcher.wit.fields.SystemState)")
                        }
                        .padding([.bottom], 10)

                        HStack {
                            Text("Created By: \(fetcher.wit.fields.SystemCreatedBy.displayName)")
                            
                            Text("Assigned To: \(fetcher.wit.fields.SystemAssignedTo.displayName)")
                        }
                        .padding([.bottom], 10)
                        
                        witIcon(type: fetcher.wit.fields.SystemWorkItemType)
                        + Text("\(fetcher.wit.fields.textPriority) \(fetcher.wit.fields.SystemTitle) \(fetcher.wit.projectLink.toRTF())")
                        + Text(": \(fetcher.wit.fields.CustomReport.toRTF())")
                    }
                    .padding([.leading, .trailing])
                }
            }
            
#if os(iOS)
            Text(self.fetcher.errorMessage ?? "") // only on iOS
#endif
        }
    }
}

struct WitView_Previews: PreviewProvider {
    static var previews: some View {
        WitView(fetcher: Fetcher())
    }
}
