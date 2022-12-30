//
//  FetchingView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 30/12/22.
//

import SwiftUI

struct FetchingView: View {
    var body: some View {
        
        VStack {
            ProgressView()
                .padding()
            
            Text("Fetching...")
        }
    }
}

struct FetchingView_Previews: PreviewProvider {
    static var previews: some View {
        FetchingView()
    }
}
