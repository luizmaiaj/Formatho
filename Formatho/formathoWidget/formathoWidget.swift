//
//  formathoWidget.swift
//  formathoWidget
//
//  Created by Luiz Carlos Maia Junior on 10/12/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    @AppStorage("organisation") private var organisation: String = ""
    @AppStorage("email") private var email: String = ""
    @AppStorage("pat") private var pat: String = ""
    @AppStorage("project") private var project: String = ""
    
    var isLoading: Bool = false                  // if waiting for the requested data
    private var errorMessage: String? = nil              // error message
    
    private let baseURL: String = "https://dev.azure.com/"
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
        SimpleEntry(date: Date(), wit: Wit())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), wit: Wit())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let header = buildHeader(pat: pat, email: email)
        
        //self.isLoading = true
        
        let witBaseUrl: String = baseURL + organisation + "/_apis/wit/workitems?ids=" + "181586"
        
        let url = NSURL(string: witBaseUrl)! as URL
        
        self.service.fetch(Wits.self, url: url, headers: header) { result in
            
            DispatchQueue.main.async {
                
                //self.isLoading = false
                
                let currentDate = Date()
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    //self.errorMessage = error.localizedDescription
                    
                    entries.append(SimpleEntry(date: currentDate, wit: Wit()))
                    
                case .success(let info):
                    if HTTP_DATA { print("Fetcher count: \(info.count)") }
                    
                    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
                    
                    entries.append(SimpleEntry(date: currentDate, wit: info.value.first ?? Wit()))
                }
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let wit: Wit
}

struct formathoWidgetEntryView : View {
    
    @AppStorage("organisation") private var organisation: String = String()
    
    var entry: Provider.Entry
    
    var body: some View {
        
        VStack {
            Text(entry.date, style: .time)
            
            Text("organisation: \(organisation)")
            
            Text(entry.wit.fields.SystemState)
        }
    }
}

@main
struct formathoWidget: Widget {
    let kind: String = "formathoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            formathoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("formatho widget")
        .description("To keep track of your wits")
        .supportedFamilies([.systemMedium])
    }
}

struct formathoWidget_Previews: PreviewProvider {
    static var previews: some View {
        formathoWidgetEntryView(entry: SimpleEntry(date: Date(), wit: Wit()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
