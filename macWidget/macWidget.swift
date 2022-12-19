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
    
    private func buildHeader(pat: String, email: String) -> [String : String] {
        
        let authorisation = "Basic " + (String(email + ":" + pat).data(using: .utf8)?.base64EncodedString() ?? "")
        
        let header = ["accept": "application/json", "authorization": authorisation]
        
        if HTTP_DATA {
            print(header)
        }
        
        return header
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), wit: Wit())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, wit: Wit())
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
    var entry: Provider.Entry
    
    var body: some View {
        Text(entry.date, style: .time)
        
        Text(entry.wit.fields.SystemTitle)
        
        Text(entry.wit.fields.SystemState)
        
        Text("\(entry.configuration.witID ?? 0)")
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
        //.supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct macWidget_Previews: PreviewProvider {
    static var previews: some View {
        macWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), wit: Wit()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
