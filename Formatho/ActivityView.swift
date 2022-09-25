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
                
                let columns = [GridItem(.fixed(60)),
                               GridItem(.flexible(minimum: 50, maximum: 110)),
                               GridItem(.flexible(minimum: 200, maximum: 400)),
                               GridItem(.fixed(110)),
                               GridItem(.fixed(90))]
                
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .leading, pinnedViews: [.sectionHeaders]) {
                        //Section(header: Text("Header")) {
                        ForEach(fetcher.activities, id: \.self) { value in
                            Text(value.activityType.capitalized)
                            Text(value.workItemType)
                            Text(value.title)
                            Text("[SCOPE-\(String(format: "%d", value.id))]")
                            Text(value.state)
                        }
                        //}
                    }
                }
                .frame(minHeight: 80)
                
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
