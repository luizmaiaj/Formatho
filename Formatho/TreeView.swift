//
//  TreeView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 7/10/22.
//

import SwiftUI

import Combine

struct TreeView: View {
    
    @AppStorage("fetched") private var fetched: [String] = [String]()
    
    @AppStorage("organisation") private var organisation: String = String()
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    
    @ObservedObject var root: Node = Node()
    
    @State var witid: String = String()
    
    func fetch() {
        
        self.fetched.removeAll()
        
        self.root.getInfo(org: organisation, pat: pat, email: email, id: witid)
    }
    
    var body: some View {
        VStack {
            
            if root.isLoading {
                
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
                
                if root.wit.id != 0 {
                    
                    TicketView(node: root)
                    
                }
                
                Text(self.root.errorMessage ?? "")
            }
        }
    }
}

struct TreeView_Previews: PreviewProvider {
    static var previews: some View {
        TreeView()
    }
}

struct TicketView: View {
    
    @AppStorage("organisation") private var organisation: String = String()
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    
    let node: Node
    var leaf: Node = Node()
    
    func getWitNumber(url: String) -> String {

        let result = url.trimmingCharacters(in: .decimalDigits)

        return String(url.dropFirst(result.count))
    }
    
    var body: some View {
        
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                //.frame(width: 200, height: 100)
                    .foregroundColor(.white)
                
                VStack {
                    Text(node.wit.fields.SystemTitle)
                    Text(node.wit.id.formatted())
                    
                    ForEach(node.wit.relations, id: \.self) { relation in
                        HStack {
                            Text(relation.attributes.name)
                            //Text(getWitNumber(url: relation.url))
                            
                            Button(getWitNumber(url: relation.url), action: {
                                node.getNode(org: organisation, pat: pat, email: email, id: getWitNumber(url: relation.url))
                            })
                        }
                    }
                }
            }
            
            if !node.nodes.isEmpty {
                ForEach(node.nodes, id: \.self) { node in
                    HStack {
                        TicketView(node: node)
                    }
                }
            }
        }
    }
}
