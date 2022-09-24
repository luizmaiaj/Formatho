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
                            .frame(alignment: .trailing)
                            .onReceive(Just(witid)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue { witid = filtered }
                            }
                            .frame(maxWidth: 125)
                            .onSubmit {
                                fetcher.wit(org: organisation, pat: pat, email: email, witid: witid)
                            }
                        
                        Button("Get WIT", action: {
                            fetcher.wit(org: organisation, pat: pat, email: email, witid: witid)
                        })
                    }
                }
                
                if !fetcher.wits.isEmpty {
                    
                    let columns = [GridItem(.fixed(20)),
                                   GridItem(.flexible(minimum: 50, maximum: 110)),
                                   GridItem(.flexible(minimum: 200, maximum: 400)),
                                   GridItem(.fixed(110)),
                                   GridItem(.flexible(minimum: 0, maximum: 400))]
                    
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .leading) {
                            ForEach(fetcher.wits, id: \.self) { value in
                                Text("P\(value.fields.MicrosoftVSTSCommonPriority)")
                                Text(value.fields.SystemWorkItemType)
                                Text(value.fields.SystemTitle)
                                Text("[SCOPE-\(String(format: "%d", value.id))]")
                                Text(value.fields.CustomReport)
                            }
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
