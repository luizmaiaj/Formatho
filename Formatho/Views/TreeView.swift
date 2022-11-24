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
    
    @StateObject var fetcher: Fetcher = Fetcher()
    
    @State var witid: String = String("")
    
    func fetch() {
        
        self.fetcher.links(org: organisation, pat: pat, email: email, id: witid)
    }
    
    var body: some View {
        VStack {
            
            if self.fetcher.isLoading {
                
                Text("Fetching...")
                
            } else {
                
                VStack {
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
                    
                    List {
                        OutlineGroup(fetcher.nodes, children: \.children) { item in
                            
                            switch item.fields.SystemWorkItemType {
                            case workItemType.epic.rawValue:
                                Text(Image(systemName: "crown.fill"))
                                    .foregroundColor(.orange)
                                + Text(" \(item.description)")
                            case workItemType.userStory.rawValue:
                                Text(Image(systemName: "book.fill"))
                                    .foregroundColor(.blue)
                                + Text(" \(item.description)")
                            case workItemType.feature.rawValue:
                                Text(Image(systemName: "trophy.fill"))
                                    .foregroundColor(.purple)
                                + Text(" \(item.description)")
                            case workItemType.issue.rawValue, workItemType.impediment.rawValue:
                                Text(Image(systemName: "cone.fill"))
                                    .foregroundColor(.purple)
                                + Text(" \(item.description)")
                            case workItemType.pbi.rawValue:
                                Text(Image(systemName: "doc.plaintext.fill"))
                                    .foregroundColor(.blue)
                                + Text(" \(item.description)")
                            case workItemType.bug.rawValue:
                                Text(Image(systemName: "ladybug.fill"))
                                    .foregroundColor(.red)
                                + Text(" \(item.description)")
                            case workItemType.task.rawValue:
                                Text(Image(systemName: "checkmark.rectangle.portrait.fill"))
                                    .foregroundColor(.yellow)
                                + Text(" \(item.description)")
                            default:
                                Text("\(item.description)")
                            }
                        }
                    }
                    .padding()
                }
                
                Text(self.fetcher.errorMessage ?? "")
            }
        }
    }
}

struct TreeView_Previews: PreviewProvider {
    static var previews: some View {
        TreeView()
    }
}
