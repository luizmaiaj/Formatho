//
//  macWidget.swift
//  macWidget
//
//  Created by Luiz Carlos Maia Junior on 15/12/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    
    @AppStorage("organisation", store: UserDefaults(suiteName: APP_GROUP)) var organisation: String = String()
    @AppStorage("email", store: UserDefaults(suiteName: APP_GROUP)) var email: String = String()
    @AppStorage("pat", store: UserDefaults(suiteName: APP_GROUP)) var pat: String = String()
    @AppStorage("project", store: UserDefaults(suiteName: APP_GROUP)) var project: String = String()
    
    private let service = APIService()
    private var wit: Wit = Wit()
    
    let fakeWit: Wit = Wit(witID: 123456, fields: Fields(areaPath: "Area Path", workItemType: "Epic", state: "New", assignedTo: User(displayName: "User", uniqueName: "user@email.com"), commentCount: 5, title: "System Title", requestor: "Custom Requestor", priority: 1))
    
    private func buildHeader(pat: String, email: String) -> [String : String] {
        
        let authorisation = "Basic " + (String(email + ":" + pat).data(using: .utf8)?.base64EncodedString() ?? "")
        
        let header = ["accept": "application/json", "authorization": authorisation]
        
        if HTTP_DATA {
            print(header)
        }
        
        return header
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), wit: fakeWit)
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        let entry = SimpleEntry(date: Date(), configuration: configuration, wit: fakeWit)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let header = buildHeader(pat: pat, email: email)
        
        //self.isLoading = true
        
        let witBaseUrl: String = BASE_URL + organisation + "/_apis/wit/workitems?ids=" + "\(configuration.witID ?? 0)" // witID
        
        let url = NSURL(string: witBaseUrl)! as URL
        
        self.service.fetch(Wits.self, url: url, headers: header) { result in
            
            DispatchQueue.main.async {
                
                //self.isLoading = false
                
                let currentDate = Date()
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    //self.errorMessage = error.localizedDescription
                    
                    entries.append(SimpleEntry(date: currentDate, configuration: configuration, wit: Wit()))
                    
                case .success(let info):
                    if HTTP_DATA { print("Fetcher count: \(info.count)") }
                    
                    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
                    
                    entries.append(SimpleEntry(date: currentDate, configuration: configuration, wit: info.value.first ?? Wit()))
                }
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let wit: Wit                    // information about the WIT
}

struct macWidgetEntryView : View {
    @AppStorage("project", store: UserDefaults(suiteName: APP_GROUP)) var project: String = String()
    
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            HStack {
                witIcon(type: entry.wit.fields.SystemWorkItemType)
                + Text("\(entry.wit.fields.textPriority) \(entry.wit.fields.SystemTitle) [\(project)-\(entry.wit.textWitID)]")
                    .fontWeight(.medium)
                + Text(": \(entry.wit.fields.SystemState)")
                    .fontWeight(.heavy)
            }
            .padding([.top, .bottom])
            
            HStack {
                Text("\(entry.wit.fields.SystemAreaPath)")
                
                if !entry.wit.fields.CustomCORequestor.isEmpty {
                    Text("\(entry.wit.fields.CustomCORequestor)")
                }
            }
            .padding([.bottom])
            
            HStack {
                Text("Assigned To: \(entry.wit.fields.SystemAssignedTo.displayName)")
                Text("Comments: \(entry.wit.fields.SystemCommentCount)")
            }
            .padding([.bottom], 10)
            
            HStack {
                
                Text(entry.date, style: .time)
                    .padding([.trailing])
                    .frame(alignment: .trailing)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.orange.gradient.opacity(0.3))
    }
}

@main
struct macWidget: Widget {
    let kind: String = "macWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            macWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("formatho widget")
        .description("To display information about your wits")
        .supportedFamilies([.systemMedium])
    }
}

struct macWidget_Previews: PreviewProvider {
    static var previews: some View {
        macWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), wit: Wit()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
