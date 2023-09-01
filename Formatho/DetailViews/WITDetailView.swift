//
//  WITDetailView.swift
//  formatho
//
//  Created by Luiz Carlos Maia Junior on 1/9/23.
//

import SwiftUI

struct WITDetailView: View {
    
    @Binding var wit: Wit
    
    @ObservedObject var fetcher: Fetcher
    
    var body: some View {
        ScrollView {
            HStack {
                if !wit.fields.CustomCORequestor.isEmpty {
                    Text("CO: \(wit.fields.CustomCORequestor)")
                }
                
                Text("Area: \(wit.fields.SystemAreaPath)")
            }
            .padding([.bottom], 10)
            
            HStack {
                Text("Last change: \(wit.fields.SystemChangedDate.formatted())")
                
                Text("State: \(wit.fields.SystemState)")
            }
            .padding([.bottom], 10)
            
            HStack {
                Text("Created By: \(wit.fields.SystemCreatedBy.displayName)")
                
                Text("Assigned To: \(wit.fields.SystemAssignedTo.displayName)")
            }
            .padding([.bottom], 10)
            
            if wit.fields.CustomReport.isEmpty {
                
                witIcon(type: wit.fields.SystemWorkItemType)
                + Text("\(wit.fields.textPriority) \(wit.fields.CustomCORequestor)  \(wit.fields.SystemTitle) \(wit.projectLink.toRTF())")
                
            } else { // if there is a report
                
                witIcon(type: wit.fields.SystemWorkItemType)
                + Text("\(wit.fields.textPriority) \(wit.fields.CustomCORequestor)  \(wit.fields.SystemTitle) \(wit.projectLink.toRTF())")
                + Text(": \(wit.fields.CustomReport.toRTF())")
                
                ReportDateView(updates: fetcher.copy(), witid: wit.witID, onlyDate: false)
                    //.padding([.top])
            }
        }
        .padding()
        
    }
}

//#Preview {
//    @StateObject var fetcher: Fetcher = Fetcher()
//    
//    WITDetailView(fetcher: fetcher)
//}
