//
//  RecentView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 25/9/22.
//

import SwiftUI

struct ActivityView: View {
    
    @AppStorage("organisation") private var organisation: String = String()
    @AppStorage("email") private var email: String = String()
    @AppStorage("pat") private var pat: String = String()
    
    @ObservedObject var fetcher: Fetcher
    
    private func fetchActivities() {
        fetcher.activities(org: organisation, pat: pat, email: email)
    }
    
    var body: some View {
        
        VStack {
            
            if fetcher.isLoading {
                
                Text("Fetching...")
                
            } else {
                
                Button("Refresh activities", action: {
                    fetchActivities()
                })
                
                ActivityTable(activities: fetcher.activities)
                
                Text(self.fetcher.errorMessage ?? "")
            }
        }
        .onAppear() {
            if fetcher.activities.isEmpty {
                fetchActivities()
            }
        }
    }
}

struct RecentView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(fetcher: Fetcher())
    }
}

struct ActivityTable: View {
    
    @State var activities: [Activity]
    
    @State private var sortOrder = [KeyPathComparator(\Activity.id)]
    
    var body: some View {
        
        Table(activities, sortOrder: $sortOrder) {
            TableColumn("Activity", value: \.activityType.capitalized)
                .width(max: 50)
            
            TableColumn("Type") { activity in
                witIcon(type: activity.workItemType)
            }
            .width(max: 30)
            
            TableColumn("Title", value: \.title)
            
            TableColumn("id", value: \.textID)
                .width(max: 50)
            
            TableColumn("State", value: \.state)
                .width(max: 90)
        }
        .onChange(of: sortOrder) {
            
            print(sortOrder.debugDescription)
            
            activities.sort(using: $0)
        }
    }
}
