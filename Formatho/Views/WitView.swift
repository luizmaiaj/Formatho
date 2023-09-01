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
            
            if fetcher.isFetchingWIT {
                
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
            
#if os(iOS)
            Text(self.fetcher.statusMessage ?? "") // only on iOS
#endif
        }
        .navigationTitle("Work Item Type")
    }
}

struct WitView_Previews: PreviewProvider {
    static var previews: some View {
        WitView(fetcher: Fetcher())
    }
}
