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
    
    @ObservedObject var fetcher: Fetcher
    
    @State var witid: String = String()
    
    var body: some View {
        VStack {
            
            if fetcher.isLoading {
                
                Text("Fetching...")
                
            } else {
                
                Form {
                    HStack {
                        
                        TextField("WIT ID", text: $witid)
                            .frame(maxWidth: 125, alignment: .trailing)
                            .onReceive(Just(witid)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue { witid = filtered }
                            }
                            .onSubmit {
                                fetcher.wit(org: organisation, pat: pat, email: email, witid: witid)
                            }
                        
                        Button("Get WIT", action: {
                            fetcher.wit(org: organisation, pat: pat, email: email, witid: witid)
                        })
                    }
                }
                
                if !fetcher.wits.isEmpty {
                    
                    Table(fetcher.wits) {
                        TableColumn("Priority") { wit in
                            Text("P" + String(format: "%d", wit.fields.MicrosoftVSTSCommonPriority))
                        }
                        TableColumn("Type", value: \.fields.SystemWorkItemType)
                        TableColumn("Title", value: \.fields.SystemTitle)
                        TableColumn("id") { wit in
                            Text("[SCOPE-\(String(format: "%d", wit.id))]")
                        }
                        TableColumn("Report") { wit in
                            Text(wit.fields.CustomReport.toRTF())
                        }
                    }
                    .frame(minHeight: 30)
                }
                
                Text(self.fetcher.errorMessage ?? "")
            }
        }
    }
}

struct WitView_Previews: PreviewProvider {
    static var previews: some View {
        WitView(fetcher: Fetcher())
    }
}
