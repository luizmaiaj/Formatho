//
//  GraphView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 30/9/22.
//

import SwiftUI
import Charts

struct GraphView: View {
    
    @ObservedObject var fetcher: Fetcher
    
    func getPriorityString(priority: Int) -> String {
        return "P" + String(format: "%d", priority)
    }
    
    var body: some View {

        if fetcher.wits.count < 2 {
            Text("Not enough data")
        } else {
            if #available(macOS 13.0, *) {
                Chart(fetcher.wits) {
                    
                    BarMark(x: .value("priority", getPriorityString(priority: $0.fields.MicrosoftVSTSCommonPriority)),
                            y: .value("count", 1))
                }
            } else {
                Text("Only available on macOS 13")
            }
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(fetcher: Fetcher())
    }
}
