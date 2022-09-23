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
            } else if fetcher.isLoading {
                
                Text("Fetching...")
                
            } else {
                
                Form {
                    HStack {
                        Button("Get projects", action: {
                            fetcher.projects(org: organisation, pat: pat, email: email)
                        })
                        
                        Button("Get account activity", action: {
                            fetcher.accountActivity(org: organisation, pat: pat, email: email)
                        })
                    }
                    
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
                
                if !fetcher.activities.isEmpty {
                    
                    List(fetcher.activities) {
                        Text($0.html)
                    }
                    .frame(minHeight: 30)
                    
                } else if !fetcher.wits.isEmpty {
                    
                    List(fetcher.wits) {
                        Text("P\($0.fields.MicrosoftVSTSCommonPriority) \($0.fields.SystemTitle) [SCOPE-\(String(format: "%d", $0.id))]: \($0.fields.CustomReport)")
                    }
                    .frame(minHeight: 30)
                }
                
                Text(self.fetcher.errorMessage ?? "")
            }
        }
        .frame(minWidth: 400)
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
