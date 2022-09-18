//
//  Fetcher.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 17/9/22.
//

import Foundation

//curl -vu luiz@newlogic.com:qnwoce4zknjxyjfxmwgidv3bj624aizdbcrusyq54alqgizxpkrq https://dev.azure.com/worldfoodprogramme/_apis/projects

class Fetcher: ObservableObject {
    @Published var projects: [Project] = [Project]()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    let service = APIService()
    
    func projects(pat: String) {
        
        //let headers = ["UserAgent": "Red8.io - iOS - Version 0.1.0 - https://red8.io"]
        
        let patBase64 = pat.data(using: .utf8)?.base64EncodedString()
        
        let headers = ["accept": "application/json",
                       "Basic": patBase64 ?? ""]
        
        self.isLoading = true
        errorMessage = nil
        
        let baseUrl: String = "https://dev.azure.com/worldfoodprogramme/_apis/projects"
        
        let url = NSURL(string: baseUrl)! as URL
        
        self.service.fetch(ADOProjectSearch.self, url: url, headers: headers) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                    case .failure(let error):
                        print("Fetcher error: \(error)")
                        self.errorMessage = error.localizedDescription
                    case .success(let info):
                        print("Fetcher count: \(info.count)")
                        self.projects = info.projects
                }
            }
        }
    }
}
