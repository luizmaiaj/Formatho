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
    @Published var activities: [Activity] = [Activity]()
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
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
        self.errorMessage = nil
        
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
    
    func queries(org: String, pat: String, email: String) {

        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        errorMessage = nil
        
        let prjBaseUrl: String = baseURL + org + "/SCOPE/_apis/wit/queries?$depth=2"
        
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

    func accountActivity(org: String, pat: String, email: String) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        self.errorMessage = nil
        
        let prjBaseUrl: String = baseURL + org + "/_apis/work/accountmyworkrecentactivity"
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(RecentActivity.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                case .failure(let error):
                    print("Fetcher error: \(error)")
                    self.errorMessage = error.localizedDescription
                case .success(let info):
                    print("Fetcher count: \(info.count)")
                    self.activities = info.value
                    
                    for activity in self.activities {
                        activity.html = "\(activity.activityType.capitalized) [SCOPE-\(String(format: "%d", activity.id))] \(activity.workItemType) \(activity.title): \(activity.state)"
                    }
                }
            }
        }

    }
    
    func wit(org: String, pat: String, email: String, witid: String) {

        self.wits(org: org, pat: pat, email: email, path: "/_apis/wit/workitems?ids=" + witid)
    }
    
    func wits(org: String, pat: String, email: String, path: String) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        errorMessage = nil
        
        let reqURL: String = baseURL + org + "/SCOPE/_workitems/edit/" //why is it necessary to put SCOPE ?
        
        let witBaseUrl: String = baseURL + org + path
        
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
                    
                    for wit in self.wits {
                        wit.html = "<b>P\(wit.fields.MicrosoftVSTSCommonPriority) \(wit.fields.SystemWorkItemType) \(wit.fields.SystemTitle)</b> <a href=\"\(reqURL)\(String(format: "%d", wit.id))\">[SCOPE-\(String(format: "%d", wit.id))]</a>: \(wit.fields.CustomReport)"
                    }
                    
                    if self.wits.count == 1 {
                        print(self.wits[0].html)
                        
                        if let data = self.wits[0].html.data(using: .unicode),
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
}
