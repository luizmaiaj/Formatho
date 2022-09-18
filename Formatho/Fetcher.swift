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
    @Published var wits: [Wit] = [Wit]()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    let service = APIService()
    
    private func buildAuthParam(pat: String, email: String) -> String {
        
        return "Basic " + (String(email + ":" + pat).data(using: .utf8)?.base64EncodedString() ?? "")
    }
    
    func projects(pat: String, email: String) {
        
        let authorisation = buildAuthParam(pat: pat, email: email)
        
        let headers = ["accept": "application/json", "authorization": authorisation]
        
        print(headers)
        
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
                        self.projects = info.value
                }
            }
        }
    }
    
    func wits(pat: String, email: String, witid: String) {
        
        let authorisation = buildAuthParam(pat: pat, email: email)
        
        let headers = ["accept": "application/json", "authorization": authorisation]
        
        print(headers)
        
        self.isLoading = true
        errorMessage = nil
        
        let baseUrl: String = "https://dev.azure.com/worldfoodprogramme/_apis/wit/workitems?ids=" + witid
        
        let url = NSURL(string: baseUrl)! as URL
        
        self.service.fetch(ADOWitSearch.self, url: url, headers: headers) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                    case .failure(let error):
                        print("Fetcher error: \(error)")
                        self.errorMessage = error.localizedDescription
                    case .success(let info):
                        print("Fetcher count: \(info.count)")
                        self.wits = info.value
                }
            }
        }
    }
}
