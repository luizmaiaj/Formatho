//
//  ContentView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 11/9/22.
//

import SwiftUI

import Combine

// PAT qnwoce4zknjxyjfxmwgidv3bj624aizdbcrusyq54alqgizxpkrq

struct ContentView: View {
    
    @ObservedObject var fetcher: Fetcher = Fetcher()
    
    @State var witid: String = String()
    
    let pat: String = String("qnwoce4zknjxyjfxmwgidv3bj624aizdbcrusyq54alqgizxpkrq")
    let email: String = String("luiz@newlogic.com")
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Form {
                Button("Get projects", action: {
                    fetcher.projects(pat: pat, email: email)
                })
                
                HStack {
                    Text("WIT ID")
                        .frame(width: 150, alignment: .leading)
                    
                    TextField("> 50001", text: $witid)
                        .frame(alignment: .trailing)
                    //.keyboardType(.numberPad)
                        .onReceive(Just(witid)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue { witid = filtered }
                        }
                    
                    Button("Get WIT", action: {
                        fetcher.wits(pat: pat, email: email, witid: witid)
                    })
                }
            }
            .frame(width: 400)
            
            if fetcher.wits.count > 0 {
                Text("P\(fetcher.wits[0].fields.MicrosoftVSTSCommonPriority) \(fetcher.wits[0].fields.SystemTitle): \(fetcher.wits[0].fields.SystemDescription)")
            }
        }
        .padding()
    }
}

// https://dev.azure.com/worldfoodprogramme/SCOPE/_workitems/edit/91860

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
