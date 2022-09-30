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
    
/*    func getPriority(priority: String) -> PlottableValue<Int> {
        switch priority {
            case "P1":
                return 1
            case "P2":
                return 2
            case "P3":
                return 3
            case "P4":
                return 4
            case "P5":
                return 5
            default:
                return 5
        }
    }*/
    
    var body: some View {

        if fetcher.wits.count < 2 {
            Text("Not enough data")
        } /*else {
            Chart(fetcher.wits) {
                
                BarMark(x: getPriority(priority: $0.fields.MicrosoftVSTSCommonPriority), y: $0.fields.SystemState)
            }
        }*/ // to be done once macOS 13 is available
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(fetcher: Fetcher())
    }
}
