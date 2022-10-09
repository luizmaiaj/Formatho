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
    
    @ObservedObject var fetcher: Fetcher
    
    @State var witid: String = String()
    
    let id: Int
    
    func fetch() {
        fetcher.links(org: organisation, pat: pat, email: email, witid: witid)
    }
    
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
                                fetch()
                            }
                        
                        Button("Get WIT", action: {
                            fetch()
                        })
                    }
                }
                
                if !fetcher.wits.isEmpty {
                    
                    TicketView(title: fetcher.wits[0].fields.SystemTitle, id: fetcher.wits[0].id)
                    
                }
                
                Text(self.fetcher.errorMessage ?? "")
            }
        }
    }
}

struct TreeView_Previews: PreviewProvider {
    static var previews: some View {
        TreeView(fetcher: Fetcher(), id: 123456)
    }
}

struct TicketView: View {
    
    let title: String
    let id: Int
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 200, height: 100)
                .foregroundColor(.white)
            
            VStack {
                Text(title)
                Text(id.formatted())
            }
        }
    }
}
