//
//  Fetcher.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 17/9/22.
//

import SwiftUI
import UniformTypeIdentifiers

#if os(OSX)
import AppKit // for clipboard access
#endif

class Fetcher: ObservableObject {
    
    @Published var projects: [Project] = [Project]()
    @Published var projectNames: [String] = [String]()
    
    @Published var wits: [Wit] = [Wit]()
    @Published var fetchers: [Fetcher] = [Fetcher]()
    
    @Published var wit: Wit = Wit()
    @Published var activities: [Activity] = [Activity]()
    @Published var query: Query = Query()
    @Published var queries: [QueryNode] = [QueryNode]()
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var formattedWIT: AttributedString = AttributedString()
    
    let baseURL: String = "https://dev.azure.com/"
    
#if os(OSX)
    let pboard = NSPasteboard.general // reference to pasteboard
#endif
    
    let service = APIService()
    
    private func getWitNumber(url: String) -> String {
        
        let result = url.trimmingCharacters(in: .decimalDigits)
        
        if result.hasSuffix("/") {
            
            return String(url.dropFirst(result.count))
        }
        else {
            return ""
        }
    }
    
    private func buildHeader(pat: String, email: String) -> [String : String] {
        
        let authorisation = "Basic " + (String(email + ":" + pat).data(using: .utf8)?.base64EncodedString() ?? "")
        
        let header = ["accept": "application/json", "authorization": authorisation]
        
        if HTTP_DATA {
            print(header)
        }
        
        return header
    }
    
    func projects(org: String, pat: String, email: String) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        self.errorMessage = nil
        
        self.projects.removeAll()
        
        let prjBaseUrl: String = baseURL + org + "/_apis/projects"
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(Projects.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR {
                        print("Fetcher error: \(error)")
                    }
                    self.errorMessage = error.localizedDescription
                case .success(let info):
                    if HTTP_DATA {
                        print("Fetcher count: \(info.count)")
                    }
                    self.projects = info.value
                    
                    self.projectNames.removeAll()
                    
                    for project in self.projects {
                        self.projectNames.append(project.name)
                    }
                }
            }
        }
    }
    
    func queries(org: String, pat: String, email: String, project: String) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        errorMessage = nil
        
        let prjBaseUrl: String = baseURL + org + "/" + project + "/_apis/wit/queries?$depth=2"
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(Queries.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                case .failure(let error):
                    print("Fetcher error: \(error)")
                    self.errorMessage = error.localizedDescription
                case .success(let info):
                    print("Fetcher count: \(info.count)")
                    self.queries = info.value
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
        
        self.service.fetch(Activities.self, url: url, headers: header) { [unowned self] result in
            
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
                        activity.html = "\(activity.activityType.capitalized) [\(String(format: "%d", activity.id))] \(activity.workItemType) \(activity.title): \(activity.state)"
                    }
                }
            }
        }
    }
    
    func wit(org: String, pat: String, email: String, witid: String, project: String) {
        
        self.wits(org: org, pat: pat, email: email, ids: [witid], project: project)
    }
    
    func wits(org: String, pat: String, email: String, ids: [String], project: String) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        errorMessage = nil
        
        self.wits.removeAll()
        
        let reqURL: String = baseURL + org + "/" + project + "/_workitems/edit/" // removing reference to name
        
        // build id list limited to 200 wits
        let listSize: Int = 200
        var iStart: Int = 0
        var iEnd: Int = min(ids.count - 1, listSize - 1)
        let batches: Int = Int(ceil(Double(ids.count / listSize)))
        
        print(batches)
        
        for _ in 0...batches {
            
            var idList: String = String()
            
            for i in iStart...iEnd {
                
                idList += ids[i] + ","
            }
            
            iStart = iEnd + 1
            iEnd = min(ids.count - 1, iEnd + listSize)
            
            idList = idList.trimmingCharacters(in: [","])
            
            print(idList)
            
            let witBaseUrl: String = baseURL + org + "/_apis/wit/workitems?ids=" + idList
            
            let url = NSURL(string: witBaseUrl)! as URL
            
            self.service.fetch(Wits.self, url: url, headers: header) { [unowned self] result in
                
                DispatchQueue.main.async {
                    
                    self.isLoading = false
                    
                    switch result {
                    case .failure(let error):
                        print("Fetcher error: \(error)")
                        self.errorMessage = error.localizedDescription
                    case .success(let info):
                        print("Fetcher count: \(info.count)")
                        self.wits += info.value
                        
                        for wit in self.wits {
                            wit.html = "<b>P\(wit.fields.MicrosoftVSTSCommonPriority) \(wit.fields.SystemWorkItemType) \(wit.fields.SystemTitle)</b> <a href=\"\(reqURL)\(String(format: "%d", wit.id))\">[\(project)-\(String(format: "%d", wit.id))]</a>: \(wit.fields.CustomReport)"
                        }
                        
                        if self.wits.count == 1 {
                            
                            self.wit = self.wits[0]
                            
                            print(self.wit.html)
                            
                            if let data = self.wit.html.data(using: .unicode),
                               let nsAttrString = try? NSAttributedString(data: data,
                                                                          options: [.documentType: NSAttributedString.DocumentType.html],
                                                                          documentAttributes: nil) {
                                
                                self.formattedWIT = AttributedString(nsAttrString) // string to be displayed in Text()
                                
#if !os(iOS)
                                self.pboard.clearContents()
                                
                                self.pboard.writeObjects(NSArray(object: nsAttrString) as! [NSPasteboardWriting])
#else
                                
                                //UIPasteboard.general.string = NSArray(object: nsAttrString)
                                UIPasteboard.general.setValue(nsAttrString, forPasteboardType: UTType.rtf)
#endif
                            }
                        }
                    }
                }
            }
        }
    }
    
    // use a query id to get the list of wit ids and then use the wits fectcher function to get information for each wit
    func query(org: String, pat: String, email: String, queryid: String, project: String) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        self.errorMessage = nil
        
        let prjBaseUrl: String = baseURL + org + "/_apis/wit/wiql?id=" + queryid
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(Query.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                case .failure(let error):
                    print("Fetcher error: \(error)")
                    self.errorMessage = error.localizedDescription
                    
                case .success(let info):
                    print("Fetcher count: \(info.workItems.count)")
                    self.query = info
                    
                    var ids: [String] = [String]()
                    
                    for workItem in self.query.workItems {
                        ids.append(String(format: "%d", workItem.id))
                    }
                    
                    if DEBUG_INFO { print(ids) }
                    
                    // call wits function to get information about the wits
                    self.wits(org: org, pat: pat, email: email, ids: ids, project: project)
                }
            }
        }
    }
    
    // queries for all the links contained in one wit
    func links(org: String, pat: String, email: String, witid: String) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        errorMessage = nil
        
        self.wits.removeAll()
        
        let witBaseUrl: String = baseURL + org + "/_apis/wit/workitems/" + witid + "?$expand=relations"
        
        let url = NSURL(string: witBaseUrl)! as URL
        
        self.service.fetch(Wit.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                case .failure(let error):
                    print("Fetcher error: \(error)")
                    self.errorMessage = error.localizedDescription
                    
                case .success(let info):
                    print("Fetcher count: \([info].count)")
                    self.wits = [info]
                    
                }
            }
        }
    }
}
