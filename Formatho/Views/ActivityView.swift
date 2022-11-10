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
    
    var body: some View {
        
        VStack {
            
            if fetcher.isLoading {
                
                Text("Fetching...")
                
            } else {
                
                Table(fetcher.activities) {
                    TableColumn("Activity", value: \.activityType.capitalized)
                    TableColumn("Type", value: \.workItemType)
                    TableColumn("Title", value: \.title)
                    TableColumn("id") { activity in
                        Text(String(format: "%d", activity.id)) // removing reference
                    }
                    TableColumn("State", value: \.state)
                }
                .frame(minHeight: 30)
                
                Text(self.fetcher.errorMessage ?? "")
            }
        }
        .onAppear() {
            fetcher.accountActivity(org: organisation, pat: pat, email: email)
        }
    }
}

struct RecentView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(fetcher: Fetcher())
    }
}
