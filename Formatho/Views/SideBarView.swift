//
//  SideBarView.swift
//  formatho
//
//  Created by Luiz Carlos Maia Junior on 26/8/23.
//

import SwiftUI

struct SideBarView: View {
    
    @Binding var selection: Tab
    
    var body: some View {
        List(selection: $selection) {
            Section("Views") {
                Label("WIT", systemImage: "crown.fill")
                    .tag(Tab.wit)
                
                Label("Activity", systemImage: "figure.run")
                    .tag(Tab.recent)
                
                Label("Query", systemImage: "list.bullet")
                    .tag(Tab.query)
                
                Label("Graph", systemImage: "chart.bar.fill")
                    .tag(Tab.graph)
                
                Label("Tree", systemImage: "tree.fill")
                    .tag(Tab.tree)
                
                Label("List", systemImage: "pencil.and.list.clipboard")
                    .tag(Tab.list)
                
            }
            
            Section("Settings") {
                Label("Login", systemImage: "person.crop.circle")
                    .tag(Tab.login)
            }
        }
    }
}

//#Preview {
//    
//    @State var selection: Tab = Tab.wit
//    
//    SideBarView(selection: $selection)
//}
