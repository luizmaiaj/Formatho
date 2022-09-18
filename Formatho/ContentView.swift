//
//  ContentView.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 11/9/22.
//

import SwiftUI

// PAT qnwoce4zknjxyjfxmwgidv3bj624aizdbcrusyq54alqgizxpkrq

struct ContentView: View {
    
    @ObservedObject var fetcher: Fetcher = Fetcher()
    
    var pat: String = String("qnwoce4zknjxyjfxmwgidv3bj624aizdbcrusyq54alqgizxpkrq")
    var email: String = String("luiz@newlogic.com")
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Button("Send request", action: {
                fetcher.projects(pat: pat, email: email)
            })
        }
        .padding()
    }
}

// https://dev.azure.com/worldfoodprogramme/SCOPE/_workitems/edit/91860

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
