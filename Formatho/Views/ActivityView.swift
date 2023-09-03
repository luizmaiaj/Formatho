//
//  RecentView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 25/9/22.
//

import SwiftUI

struct ActivityView: View {
    
    @ObservedObject var fetcher: Fetcher
    
    @Binding var selectedWIT: Activity.ID?
    
    private func fetchActivities() {
        fetcher.getActivities()
    }
    
    var body: some View {
        
        VStack {
            
            if fetcher.isFetchingActivity {
                
                FetchingView()
                
            } else {
                
//                Button("Refresh activities", action: {
//                    fetchActivities()
//                })
                
                ActivityTable(activities: fetcher.activities, selectedWIT: $selectedWIT)
            }
        }
        .onAppear() {
            if fetcher.activities.isEmpty {
                fetchActivities()
            }
        }
    }
}

//struct RecentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityView(fetcher: Fetcher())
//    }
//}

struct ActivityTable: View {
    
    @State var activities: [Activity]
    
    @State private var sortOrder = [KeyPathComparator(\Activity.id)]
    
    @Binding var selectedWIT: Activity.ID?
    
    var body: some View {
        
#if os(macOS)
        Table(activities, selection: $selectedWIT, sortOrder: $sortOrder) {
            
            TableColumn("Activity", value: \.activityType.capitalized)
                .width(max: 50)
            
            TableColumn("Type") { activity in
                witIcon(type: activity.workItemType)
            }
            .width(max: 30)
            
            TableColumn("Title", value: \.title)
            
            TableColumn("id") { activity in
                Text("\(activity.idLink.toRTF())")
            }
            .width(max: 50)
            
            TableColumn("State", value: \.state)
                .width(max: 90)
        }
        .onChange(of: sortOrder) {
            
            activities.sort(using: $0)
        }
#else
        List {
            ForEach(activities) { activity in
                HStack {
                    
                    Text(activity.activityType.capitalized)
                    
                    VStack {
                        witIcon(type: activity.workItemType)
                        Text(activity.textID)
                    }

                    VStack {
                        Text(activity.state)
                        Text(activity.title)
                    }
                }
            }
        }
#endif
    }
}
