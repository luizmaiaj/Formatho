//
//  WitTableView.swift
//  formatho
//
//  Created by Luiz Carlos Maia Junior on 11/2/23.
//

import SwiftUI

struct WitTableView: View {
    
    @State var wits: [Wit]
    
    @State private var sortOrder = [KeyPathComparator(\Wit.id)]
    
    @ObservedObject var fetcher: Fetcher
    
    var body: some View {
        
        Table(wits, sortOrder: $sortOrder) {
            TableColumn("Priority", value: \.fields.textPriority)
                .width(max: 30)
            
            TableColumn("Type") { wit in
                witIcon(type: wit.fields.SystemWorkItemType)
            }
            .width(max: 30)
            
            TableColumn("Title", value: \.fields.SystemTitle)
            
            TableColumn("id") { wit in
                Text(wit.idLink.toRTF())
            }
                .width(max: 50)
            
            TableColumn("Report") { wit in
                Text(wit.fields.CustomReport.toRTF())
            }
            
            TableColumn("Updated") { wit in
                ReportDateView(updates: fetcher.copy(), witid: wit.witID)
            }
            .width(max: 130)
        }
        .onChange(of: sortOrder) {
            
            wits.sort(using: $0)
        }
    }
}

struct WitTableView_Previews: PreviewProvider {
    static var previews: some View {
        WitTableView(wits: [Wit](), fetcher: Fetcher())
    }
}
