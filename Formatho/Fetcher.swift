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
#else
import MobileCoreServices
#endif

class Fetcher: ObservableObject {
    
    @AppStorage("project") private var project: String = String()
    
    @Published var projects: [Project] = [Project]()        // to store the list of projects in the organisation
    @Published var projectNames: [String] = [String]()      // list of project names to display in the interface picker
    
    @Published var wits: [Wit] = [Wit]()                    // to store the list of wits from the result of a query
    @Published var nodes: [WitNode] = [WitNode]()           // to store the list of wits in a hierarchy
    
    @Published var wit: Wit = Wit()                         // single wit
    @Published var activities: [Activity] = [Activity]()    // for the latest 200 items the user has worked on
    @Published var query: Query = Query()                   // for the list of wits on a query
    @Published var queries: [QueryNode] = [QueryNode]()     // to store the list of queries in a hierarchy
    
    @Published var isLoading: Bool = false                  // if waiting for the requested data
    @Published var statusMessage: String? = nil
    @Published var errorMessage: String? = nil              // error message to be displayed on the interface
    @Published var formattedWIT: AttributedString = AttributedString() // to manage the string that is copied to the clipboard
    
    private var fetched: [Int] = [Int]()                    // list fetched for the wit links' tree
    
    let baseURL: String = "https://dev.azure.com/"
    
#if os(OSX)
    let pboard = NSPasteboard.general // reference to pasteboard
#endif
    
    let service = APIService()
    
    private func buildHeader(pat: String, email: String) -> [String : String] {
        
        let authorisation = "Basic " + (String(email + ":" + pat).data(using: .utf8)?.base64EncodedString() ?? "")
        
        let header = ["accept": "application/json", "authorization": authorisation]
        
        if HTTP_DATA {
            print(header)
        }
        
        return header
    }
    
    // return a formatted query name and id for the prints
    private func printQuery(title: String, query: QueryNode) {
        
        if DEBUG_INFO { print("\(title) \(query.name):\(query.id)") }
    }
    
    // to get the list of projects accessible to the user
    func projects(org: String, pat: String, email: String) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        self.errorMessage = nil
        
        self.projects.removeAll()
        self.projectNames.removeAll()
        
        let prjBaseUrl: String = self.baseURL + org + "/_apis/projects"
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(Projects.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    self.errorMessage = error.localizedDescription
                    
                case .success(let info):
                    if HTTP_DATA { print("Fetcher count: \(info.count)") }
                    
                    self.projects = info.value
                    
                    for project in self.projects {
                        self.projectNames.append(project.name)
                    }
                    
                    // if there's no project set, set it as the first on the list retrieved
                    if self.project.count == 0 && !self.projects.isEmpty {
                        
                        self.project = self.projects.first?.name ?? ""
                    }
                }
            }
        }
    }
    
    // to get the list of queries accessible to the user
    func queries(org: String, pat: String, email: String, project: String) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        errorMessage = nil
        statusMessage = nil
        
        let prjBaseUrl: String = self.baseURL + org + "/" + project + "/_apis/wit/queries?$depth=1"
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(Queries.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    self.errorMessage = error.localizedDescription
                    
                case .success(let info):
                    if HTTP_DATA { print("Fetcher count: \(info.count)") }
                    
                    self.queries = info.value
                    
                    for q in 0...(self.queries.count - 1) {
                        
                        self.printQuery(title: "ROOT", query: self.queries[q])
                        
                        if self.queries[q].children != nil { // must have children as this first query is on the root folder
                            
                            for c in 0...(self.queries[q].children!.count - 1) { // already checked if array is not empty
                                
                                if self.queries[q].children![c].isFolder {
                                    
                                    self.printQuery(title: "GET CHILDREN", query: self.queries[q].children![c])
                                    
                                    self.statusMessage = self.queries[q].children![c].name
                                    
                                    self.queries(org: org, pat: pat, email: email, project: project, queryID: self.queries[q].children![c].id, completion: { query in
                                        
                                        self.queries[q].children![c] = query
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func queries(org: String, pat: String, email: String, project: String, queryID: String, completion: @escaping (QueryNode) -> Void) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        self.statusMessage = queryID
        
        let prjBaseUrl: String = self.baseURL + org + "/" + project + "/_apis/wit/queries/" + queryID + "?$depth=1"
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(QueryNode.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                //self.isLoading = false // moved to just before completion to avoid having the screen flashing
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    self.errorMessage = error.localizedDescription
                    
                    self.isLoading = false  // under test
                    
                    completion(QueryNode())
                    
                case .success(let info):
                    
                    self.printQuery(title: "REC parent", query: info)
                    
                    if info.isFolder && info.children != nil {
                        
                        for c in 0...(info.children!.count - 1) {
                            
                            if info.children![c].isFolder {
                                
                                if DEBUG_INFO { self.printQuery(title: "REC children", query: info.children![c]) }
                                
                                self.queries(org: org, pat: pat, email: email, project: project, queryID: info.children![c].id, completion: { query in
                                    
                                    if query.children != nil {
                                        info.children![c] = query
                                    }
                                })
                            }
                        }
                    }
                    
                    self.isLoading = false // under test
                    
                    completion(info)
                }
            }
        }
    }
    
    // to get the list of the most recent wits that the user has worked on (limited to 200)
    func activities(org: String, pat: String, email: String) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        self.errorMessage = nil
        
        let prjBaseUrl: String = self.baseURL + org + "/_apis/work/accountmyworkrecentactivity"
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(Activities.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    self.errorMessage = error.localizedDescription
                    
                case .success(let info):
                    if HTTP_DATA { print("Fetcher count: \(info.count)") }
                    
                    self.activities = info.value
                }
            }
        }
    }
    
    func wit(org: String, pat: String, email: String, witid: String, project: String) {
        
        self.wits(org: org, pat: pat, email: email, ids: [witid], project: project)
    }
    
    func wits(org: String, pat: String, email: String, ids: [String], project: String, cb: Bool = false, addReport: Bool = true) {
        
        if ids.isEmpty { // if no ids in the list then simply return *** add some error handling ? ***
            
            self.errorMessage = "No ids on query"
            
            return
        }
        
        let header = buildHeader(pat: pat, email: email)
        var report: String = String("")
        
        self.isLoading = true
        errorMessage = nil
        
        self.wits.removeAll()
        
        let reqURL: String = self.baseURL + org + "/" + project + "/_workitems/edit/" // removing reference to name
        
        // build id list limited to ADO_LIST_LIMIT = 200 wits
        var iStart: Int = 0
        var iEnd: Int = max(min(ids.count - 1, ADO_LIST_LIMIT - 1), 0) // cannot be less than zero, protection for the for block inside the batch in case the id list count at the top does not filter this error out
        let batches: Int = Int(ceil(Double(ids.count / ADO_LIST_LIMIT)))
        
        print(batches)
        
        for _ in 0...batches {
            
            var idList: String = String()
            
            for i in iStart...iEnd {
                
                idList += ids[i] + ","
            }
            
            iStart = iEnd + 1
            iEnd = min(ids.count - 1, iEnd + ADO_LIST_LIMIT)
            
            idList = idList.trimmingCharacters(in: [","])
            
            if DEBUG_INFO { print("Fetcher::wits \(idList)") }
            
            let witBaseUrl: String = baseURL + org + "/_apis/wit/workitems?ids=" + idList
            
            let url = NSURL(string: witBaseUrl)! as URL
            
            self.service.fetch(Wits.self, url: url, headers: header) { [unowned self] result in
                
                DispatchQueue.main.async {
                    
                    self.isLoading = false
                    
                    switch result {
                    case .failure(let error):
                        if HTTP_ERROR { print("Fetcher error: \(error)") }
                        
                        self.errorMessage = error.localizedDescription
                        
                    case .success(let info):
                        if HTTP_DATA { print("Fetcher count: \(info.count)") }
                        
                        self.wits += info.value
                        
                        for wit in self.wits {
                            
                            // splitting between link and name to correctly display in dark mode
                            wit.link = "<a href=\"\(reqURL)\(wit.textWitID)\">[\(project)-\(wit.textWitID)]</a>"
                            
                            wit.html = wit.name + " " + wit.link
                            
                            //add report field information if necessary
                            if addReport {
                                
                                wit.html +=  ": \(wit.fields.CustomReport)"
                                
                            } else {
                                
                                wit.html +=  "<br>" // add line break if report is not added
                            }
                            
                            report += wit.html
                        }
                        
                        // if query was for only one item or multiple items but 'add to clipboard' was selected
                        if self.wits.count == 1 || cb {
                            
                            self.wit = self.wits[0]
                            
                            if self.wits.count == 1 {
                                report = self.wit.html
                            }
                            
                            if DEBUG_INFO { print(report) }
                            
                            if let data = report.data(using: .unicode),
                               let nsAttrString = try? NSAttributedString(data: data,
                                                                          options: [.documentType: NSAttributedString.DocumentType.html],
                                                                          documentAttributes: nil) {
                                
                                self.formattedWIT = AttributedString(nsAttrString) // string to be displayed in Text()
                                
#if os(OSX)
                                self.pboard.clearContents()
                                
                                self.pboard.writeObjects(NSArray(object: nsAttrString) as! [NSPasteboardWriting])
#else
                                
                                do {
                                    let rtf = try nsAttrString.data(from: NSMakeRange(0, nsAttrString.length), documentAttributes: [NSAttributedString.DocumentAttributeKey.documentType : NSAttributedString.DocumentType.rtf])
                                    
                                    //UIPasteboard.general.setData(rtf, forPasteboardType: kUTTypeRTF as String)
                                    UIPasteboard.general.setData(rtf, forPasteboardType: "public.rtf")
                                    
                                } catch {
                                    
                                    print("ERROR on pasteboard")
                                }
#endif
                            }
                        }
                    }
                }
            }
        }
    }
    
    // use a query id to get the list of wit ids and then use the wits fectcher function to get information for each wit
    func query(org: String, pat: String, email: String, queryid: String, project: String, cb: Bool, addReport: Bool) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        self.errorMessage = nil
        
        let prjBaseUrl: String = self.baseURL + org + "/_apis/wit/wiql?id=" + queryid
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(Query.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    self.errorMessage = error.localizedDescription
                    
                case .success(let info):
                    if HTTP_DATA { print("Fetcher count: \(info.workItems.count)") }
                    
                    self.query = info
                    
                    // build id list to query for the details on wits
                    var ids: [String] = [String]()
                    
                    for workItem in self.query.workItems {
                        ids.append(String(format: "%d", workItem.id))
                    }
                    
                    if DEBUG_INFO { print(ids) }
                    
                    // call wits function to get information about the wits
                    self.wits(org: org, pat: pat, email: email, ids: ids, project: project, cb: cb, addReport: addReport)
                }
            }
        }
    }
    
    // queries for all the links contained in one wit
    func links(org: String, pat: String, email: String, id: String) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        errorMessage = nil
        //self.statusMessage = id
        
        self.nodes.removeAll()
        
        self.fetched.removeAll()
        
        let witBaseUrl: String = self.baseURL + org + "/_apis/wit/workitems/" + id + "?$expand=relations"
        
        let url = NSURL(string: witBaseUrl)! as URL
        
        self.service.fetch(WitNode.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                // self.isLoading = false // testing
                
                switch result {
                    
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    self.errorMessage = error.localizedDescription
                    
                case .success(let info):
                    if HTTP_DATA { print("Fetcher count: \([info].count)") }
                    
                    self.nodes = [info]
                    
                    self.fetched.append(info.witID)
                    if DEBUG_INFO { print("fetched: \(self.fetched)") }
                    
                    for n in 0...(self.nodes.count - 1) {
                        
                        if self.nodes[n].children != nil {
                            
                            let cMax = max((self.nodes[n].children?.count ?? 0) - 1, 0) // cannot be less than zero
                            
                            for c in 0...(cMax) {
                                
                                if !self.fetched.contains(self.nodes[n].children![c].witID) && self.nodes[n].children![c].nodeType != relation.file && self.nodes[n].children![c].nodeType != relation.pullRequest {
                                    
                                    self.links(org: org, pat: pat, email: email, id: self.nodes[n].children![c].witID, completion: { [self] node in
                                        
                                        if node.witID != 0 {
                                            self.nodes[n].children![c] = node
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
                
                self.isLoading = false
            }
        }
    }
    
    func links(org: String, pat: String, email: String, id: Int, completion: @escaping (WitNode) -> Void) {
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        //self.statusMessage = "\(id)"
        
        let witBaseUrl: String = self.baseURL + org + "/_apis/wit/workitems/" + "\(id)" + "?$expand=relations"
        
        let url = NSURL(string: witBaseUrl)! as URL
        
        self.service.fetch(WitNode.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                    
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error wit id \(id): \(error)") }
                    
                    self.errorMessage = error.localizedDescription
                    
                    completion(WitNode())
                    
                case .success(let info):
                    if HTTP_DATA { print("Fetcher count: \([info].count)") }
                    
                    self.fetched.append(info.witID)
                    
                    if DEBUG_INFO { print("fetched: \(self.fetched)") }
                    
                    let cMax = max((info.children?.count ?? 0) - 1, 0) // cannot be less than zero
                    
                    for c in 0...(cMax) {
                        
                        if !self.fetched.contains(info.children![c].witID) && info.children![c].nodeType != relation.file && info.children![c].nodeType != relation.pullRequest {
                            
                            self.links(org: org, pat: pat, email: email, id: info.children![c].witID, completion: { node in
                                
                                if node.witID != 0 {
                                    info.children![c] = node
                                }
                            })
                        }
                    }
                                        
                    completion(info)
                }
            }
        }
    }
}
