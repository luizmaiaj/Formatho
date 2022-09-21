//
//  Main.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 21/9/22.
//

import SwiftUI

import Combine // for Just

struct Main: View {
    
    @ObservedObject var fetcher: Fetcher
    
    @AppStorage("organisation") private var organisation: String = String()
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    
    @State var witid: String = String()
    
    @State var isPresentedLogin = false
    
    var body: some View {
        VStack {
            
            if isPresentedLogin {
                Form {
                    TextField("organisation", text: $organisation)
                    
                    TextField("email", text: $email)
                    
                    TextField("PAT", text: $pat)
                }
            }
            
            Form {
                /*Button("Get projects", action: {
                    fetcher.projects(org: organisation, pat: pat, email: email)
                })*/
                
                HStack {
                    TextField("WIT ID", text: $witid)
                        .frame(alignment: .trailing)
                        .onReceive(Just(witid)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue { witid = filtered }
                        }
                        .onSubmit {
                            fetcher.wits(org: organisation, pat: pat, email: email, witid: witid)
                        }
                    
                    Button("Get WIT", action: {
                        fetcher.wits(org: organisation, pat: pat, email: email, witid: witid)
                    })
                }
            }
            .frame(minWidth: 300)
            
            if fetcher.isLoading {
                
                Text("Fetching...")
                
            } else if fetcher.errorMessage != nil {
                
                Text(self.fetcher.errorMessage ?? "")
                
            } else if fetcher.wits.count > 0 {
                
                HStack{
                    Text("Copied to clipboard:")
                        .font(.body)
                    
                    Text(fetcher.formattedWIT)
                }
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

struct Main_Previews: PreviewProvider {
    
    static var previews: some View {
        Main(fetcher: Fetcher())
    }
}
