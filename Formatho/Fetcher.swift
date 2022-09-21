//
//  Fetcher.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 17/9/22.
//

import Foundation

import AppKit // for clipboard access

class Fetcher: ObservableObject {
    @Published var projects: [Project] = [Project]()
    @Published var wits: [Wit] = [Wit]()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var rawWIT: String = String()
    @Published var htmlWIT: String = String()
    @Published var formattedWIT: AttributedString = AttributedString()
    
    let baseURL: String = "https://dev.azure.com/"
    
    let pboard = NSPasteboard.general // reference to pasteboard
    
    let service = APIService()
    
    private func buildHeader(pat: String, email: String) -> [String : String] {
        
        let authorisation = "Basic " + (String(email + ":" + pat).data(using: .utf8)?.base64EncodedString() ?? "")
        
        let header = ["accept": "application/json", "authorization": authorisation]
        
        print(header)
        
        return header
    }
    
    func projects(org: String, pat: String, email: String) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        errorMessage = nil
        
        let prjBaseUrl: String = baseURL + org + "/_apis/projects"
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(ADOProjectSearch.self, url: url, headers: header) { [unowned self] result in
            
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
    
    func wits(org: String, pat: String, email: String, witid: String) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        errorMessage = nil
        
        let reqURL: String = baseURL + org + "/SCOPE/_workitems/edit/" //why is it necessary to put SCOPE ?
        
        let witBaseUrl: String = baseURL + org + "/_apis/wit/workitems?ids=" + witid
        
        let url = NSURL(string: witBaseUrl)! as URL
        
        self.service.fetch(ADOWitSearch.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                case .failure(let error):
                    print("Fetcher error: \(error)")
                    self.errorMessage = error.localizedDescription
                case .success(let info):
                    print("Fetcher count: \(info.count)")
                    self.wits = info.value
                    
                    self.rawWIT = "P\(info.value[0].fields.MicrosoftVSTSCommonPriority) \(info.value[0].fields.SystemTitle) [SCOPE-\(String(format: "%d", info.value[0].id))]: \(info.value[0].fields.CustomReport)"
                    self.htmlWIT = "<b>P\(info.value[0].fields.MicrosoftVSTSCommonPriority) \(info.value[0].fields.SystemTitle)</b> <a href=\"\(reqURL)\(String(format: "%d", info.value[0].id))\">[SCOPE-\(String(format: "%d", info.value[0].id))]</a>: \(info.value[0].fields.CustomReport)"
                    
                    let fullHTML = self.htmlWIT
                    
                    print(info.value[0].url)
                    
                    print(fullHTML)
                    
                    if let data = fullHTML.data(using: .unicode),
                       let nsAttrString = try? NSAttributedString(data: data,
                                                                  options: [.documentType: NSAttributedString.DocumentType.html],
                                                                  documentAttributes: nil) {
                        
                        self.formattedWIT = AttributedString(nsAttrString) // string to be displayed in Text()
                        
                        self.pboard.clearContents()
                        
                        self.pboard.writeObjects(NSArray(object: nsAttrString) as! [NSPasteboardWriting])
                    }
                }
            }
        }
    }
}
