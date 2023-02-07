//
//  ReportDateView.swift
//  formatho
//
//  Created by Luiz Carlos Maia Junior on 7/2/23.
//

import SwiftUI

struct ReportDateView: View {
    
    @StateObject var updates: Fetcher = Fetcher()
    
    var org: String
    var email: String
    var pat: String
    var project: String
    
    var witid: Int
    
    var onlyDate: Bool = true
    
    @State var lastReportUpdate: String = "no date"
    
    func findLastReportUpdate() {
        
        updates.updates.reverse() // the updates list starts with the oldest
        
        for update in updates.updates {
            
            if !update.fields.CustomReport.newValue.isEmpty {
                
                lastReportUpdate = update.fields.SystemRevisedDate.oldValue.formatted() // the revised date out of the fields list seems to be wrong when it's the first review
                
                //print("ReportDateView \(lastReportUpdate)")
                
                break
            }
        }
    }
    
    var body: some View {
        
        HStack {
            if updates.isLoading {
                
                if onlyDate {
                    
                    Text("Fething...")
                    
                } else {
                    
                    FetchingView()
                }
                
            } else {
                
                if onlyDate {
                    Text("\(lastReportUpdate)")
                } else {
                    Text("Report updated on: \(lastReportUpdate)")
                }
            }
        }
        .onAppear() {
            
            if updates.updates.isEmpty {
                
                updates.initialise(org: self.org, email: self.email, pat: self.pat, project: self.project)
                
                updates.getUpdates(id: witid) {
                    
                    findLastReportUpdate()
                }
            }
        }
    }
}

struct ReportDateView_Previews: PreviewProvider {
    static var previews: some View {
        ReportDateView(org: "org", email: "email", pat: "pat", project: "project", witid: 50000)
    }
}
