//
//  WitView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 25/9/22.
//

import SwiftUI

import Combine

struct WitView: View {
    
    @AppStorage("organisation") private var organisation: String = String()
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    @AppStorage("project") private var project: String = String()
    
    @ObservedObject var fetcher: Fetcher
    
    @State var witid: String = String()
    
    func fetch() {
        fetcher.wit(org: organisation, pat: pat, email: email, witid: witid, project: project)
    }
    
    var body: some View {
        VStack {
            
            if fetcher.isLoading {
                
                Text("Fetching...")
                
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
                    
                    Group {
                        HStack {
                            Text("State: \(fetcher.wit.fields.SystemState)")
                            
                            if !fetcher.wit.fields.CustomCORequestor.isEmpty {
                                Text("CO: \(fetcher.wit.fields.CustomCORequestor)")
                            }
                        }
                        witIcon(type: fetcher.wit.fields.SystemWorkItemType)
                        + Text("\(fetcher.wit.fields.textPriority) \(fetcher.wit.fields.SystemTitle) \(fetcher.wit.link.toRTF())")
                        + Text(": \(fetcher.wit.fields.CustomReport.toRTF())")
                    }
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
