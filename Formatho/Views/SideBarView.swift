//
//  SideBarView.swift
//  formatho
//
//  Created by Luiz Carlos Maia Junior on 26/8/23.
//

import SwiftUI

struct SideBarView: View {
    
    @AppStorage("organisation", store: UserDefaults(suiteName: APP_GROUP)) var organisation: String = String()
    @AppStorage("email", store: UserDefaults(suiteName: APP_GROUP)) var email: String = String()
    @AppStorage("pat", store: UserDefaults(suiteName: APP_GROUP)) var pat: String = String()
    @AppStorage("project", store: UserDefaults(suiteName: APP_GROUP)) var project: String = String()
    
    @Binding var selection: Tab?
    
    @ObservedObject var queriesFetcher: Fetcher
    
    var body: some View {
        
        List(selection: $selection) {
            
            if (!organisation.isEmpty && !pat.isEmpty && !email.isEmpty && !project.isEmpty) {
                
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
            }
            
            Section("Settings") {
                Label("Login", systemImage: "person.crop.circle")
                    .tag(Tab.login)
                
                Label("Config", systemImage: "gearshape.fill")
                    .tag(Tab.config)
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                queriesFetcher.getQueries() // update the list of queries
            } label: {
                Label("Refresh Queries", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderless)
            .foregroundColor(.accentColor)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .keyboardShortcut(KeyEquivalent("r"), modifiers: .command)
        }
    }
}

//#Preview {
//
//    @State var selection: Tab = Tab.wit
//
//    SideBarView(selection: $selection)
//}
