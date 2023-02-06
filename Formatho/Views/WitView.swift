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
                        
                        ReportDateView(org: fetcher.organisation, email: fetcher.email, pat: fetcher.pat, project: fetcher.project, witid: fetcher.wit.witID, onlyDate: false)
                            .padding([.top])
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

struct ReportDateView: View {
    
    @StateObject var updates: Fetcher = Fetcher()
    
    var org: String
    var email: String
    var pat: String
    var project: String
    
    var witid: Int
    
    var onlyDate: Bool = true
    
    @State var lastReportUpdate: String = "no date"
    
    func findLastReportUpdate() {
        
        updates.updates.reverse() // the updates list starts with the oldest
        
        for update in updates.updates {
            
            if !update.fields.CustomReport.newValue.isEmpty {
                
                lastReportUpdate = update.revisedDate.formatted()
                
                break
            }
        }
    }
    
    var body: some View {
        
        HStack {
            if updates.isLoading {
                
                if onlyDate {
                    
                    Text("Fething...")
                    
                } else {
                    FetchingView()
                }
                
            } else {
                
                if onlyDate {
                    Text("\(lastReportUpdate)")
                } else {
                    Text("Report updated on: \(lastReportUpdate)")
                }
            }
        }
        .onAppear() {
            
            if updates.updates.isEmpty {
                
                updates.initialise(org: self.org, email: self.email, pat: self.pat, project: self.project)
                
                updates.getUpdates(id: witid) {
                    
                    findLastReportUpdate()
                }
            }
        }
    }
}

struct WitView_Previews: PreviewProvider {
    static var previews: some View {
        WitView(fetcher: Fetcher())
    }
}
