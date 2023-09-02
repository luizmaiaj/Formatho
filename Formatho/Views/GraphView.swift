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
    
    var body: some View {

        Group {
            if fetcher.wits.count < 2 {
                
                Text("Not enough data")
                
            } else {
                
                Chart(fetcher.wits) {
                    
                    BarMark(x: .value("priority", $0.fields.textPriority),
                            y: .value("count", 1))
                }
            }
        }
        .frame(minHeight: 30)
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(fetcher: Fetcher())
    }
}
