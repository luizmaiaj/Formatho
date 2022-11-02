//
//  WitTab.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 2/11/22.
//

import SwiftUI

struct WitTab: View {
    @ObservedObject var fetcher: Fetcher
    
    var body: some View {
        NavigationView {
            WitView(fetcher: fetcher)
        }
    }
}

struct WitTab_Previews: PreviewProvider {
    static var previews: some View {
        WitTab(fetcher: Fetcher())
    }
}
