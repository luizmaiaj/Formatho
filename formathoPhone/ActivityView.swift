//
//  ActivityView.swift
//  formathoPhone
//
//  Created by Luiz Carlos Maia Junior on 20/1/23.
//

import SwiftUI

struct ActivityView: View {
    
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
                    
                List {
                    ForEach(fetcher.activities, id: \.self) {
                        
                        Text("\($0.activityType.capitalized): \(witIcon(type: $0.workItemType)) \($0.textID) \($0.title): \($0.state)")
                    }
                }
            }
        }
        .onAppear() {
            if fetcher.activities.isEmpty {
                fetchActivities()
            }
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(fetcher: Fetcher())
    }
}
