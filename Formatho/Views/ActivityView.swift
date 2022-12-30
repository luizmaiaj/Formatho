//
//  RecentView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 25/9/22.
//

import SwiftUI

struct ActivityView: View {
    
    @AppStorage("organisation", store: UserDefaults(suiteName: APP_GROUP)) var organisation: String = String()
    @AppStorage("email", store: UserDefaults(suiteName: APP_GROUP)) var email: String = String()
    @AppStorage("pat", store: UserDefaults(suiteName: APP_GROUP)) var pat: String = String()
    @AppStorage("project", store: UserDefaults(suiteName: APP_GROUP)) var project: String = String()

    @ObservedObject var fetcher: Fetcher
    
    private func fetchActivities() {
        fetcher.getActivities()
    }
    
    var body: some View {
        
        VStack {
            
            if fetcher.isLoading {
                
                FetchingView()
                
            } else {
                
                Button("Refresh activities", action: {
                    fetchActivities()
                })
                
                ActivityTable(activities: fetcher.activities)
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
            
            activities.sort(using: $0)
        }
    }
}
