//
//  ContentView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 11/9/22.
//

import SwiftUI

import Combine // for Just

struct ContentView: View {
    
    @ObservedObject var fetcher: Fetcher = Fetcher()
    
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    
    @State var witid: String = String()
    
    @State var isPresentedLogin = false
    
    var body: some View {
        VStack {
            
            if isPresentedLogin {
                Form {
                    TextField("email", text: $email)
                        
                    TextField("PAT", text: $pat)
                }
            }
            
            Form {
                Button("Get projects", action: {
                    fetcher.projects(pat: pat, email: email)
                })
                
                HStack {
                    Text("WIT ID")
                        .frame(width: 50, alignment: .leading)
                    
                    TextField("> 50001", text: $witid)
                        .frame(alignment: .trailing)

                        .onReceive(Just(witid)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue { witid = filtered }
                        }
                    
                    Button("Get WIT", action: {
                        fetcher.wits(pat: pat, email: email, witid: witid)
                    })
                }
            }
            .frame(minWidth: 300)
            
            if fetcher.wits.count > 0 {
                Text(fetcher.formattedWIT)
            }
        }
        .toolbar {
            ToolbarItem {
                
                Button {
                    isPresentedLogin.toggle()
                } label: {
                    HStack {
                        
                        if email.isEmpty {
                            Text("Login details")
                        } else {
                            Text(email)
                        }
                        
                        Image(systemName: "person.circle")
                            .font(.title2)
                    }
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
