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
    
    @AppStorage("sortPriority") private var sortPriority: Bool = false
    
    @Published var projects: [Project] = [Project]()        // to store the list of projects in the organisation
    @Published var projectNames: [String] = [String]()      // list of project names to display in the interface picker
    
    @Published var wits: [Wit] = [Wit]()                    // to store the list of wits from the result of a query
    @Published var updates: [Update] = [Update]()           // to store the list of updates for a wit
    @Published var root: WitNode = WitNode()           // to store the list of wits in a hierarchy
    
    @Published var wit: Wit = Wit()                         // single wit
    @Published var activities: [Activity] = [Activity]()    // for the latest 200 items the user has worked on
    @Published var query: Query = Query()                   // for the list of wits on a query
    @Published var queries: [QueryNode] = [QueryNode]()     // to store the list of queries in a hierarchy
    
    @Published var isFetchingWIT: Bool = false                  // if waiting for the requested data
    @Published var isFetchingActivity: Bool = false                  // if waiting for the requested data
    @Published var statusMessage: String? = nil              // error message to be displayed on the interface
    @Published var formattedWIT: AttributedString = AttributedString() // to manage the string that is copied to the clipboard
    
    private var fetched: [Int] = [Int]()                    // list fetched for the wit links' tree
    
    var organisation: String = String()
    var email: String = String()
    var pat: String = String()
    var project: String = String()
    
    private var header: [String : String] = [String : String]()
    
#if os(OSX)
    let pboard = NSPasteboard.general // reference to pasteboard
#endif
    
    let service = APIService()
    
    private func buildHeader() {
        
        let authorisation = "Basic " + (String(self.email + ":" + self.pat).data(using: .utf8)?.base64EncodedString() ?? "")
        
        self.header = ["accept": "application/json", "authorization": authorisation]
        
        if HTTP_DATA {
            print(self.header)
        }
    }
    
    // return a formatted query name and id for the prints
    private func printQuery(title: String, query: QueryNode) {
        
        if DEBUG_INFO { print("\(title) \(query.name):\(query.id)") }
    }
    
    func copy() -> Fetcher {
        let fetcher = Fetcher()
        
        fetcher.organisation = self.organisation
        fetcher.email = self.email
        fetcher.pat = self.pat
        fetcher.project = self.project
        
        fetcher.buildHeader()
        
        return fetcher
    }
    
    func copy(fetcher: Fetcher) {
        
        self.organisation = fetcher.organisation
        self.email = fetcher.email
        self.pat = fetcher.pat
        self.project = fetcher.project
        
        buildHeader()
    }
    
    func setProject(project: String) {
        
        self.project = project
    }
    
    func initialise(org: String, email: String, pat: String, project: String) {
        
        self.organisation = org
        self.email = email
        self.pat = pat
        self.project = project
        
        buildHeader()
    }
    
    // to get the list of projects accessible to the user
    // as it's being called from the login view the login info can also be updated inside the class
    func getProjects(org: String, email: String, pat: String) {
        
        self.organisation = org
        self.email = email
        self.pat = pat
        
        buildHeader() // maybe this is not necessary ***
        
        self.isFetchingWIT = true
        self.statusMessage = nil
        
        self.projects.removeAll()
        self.projectNames.removeAll()
        
        let prjBaseUrl: String = BASE_URL + org + "/_apis/projects"
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(Projects.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isFetchingWIT = false
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    self.statusMessage = error.localizedDescription
                    
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
                    
                    self.statusMessage = "\(self.projects.count) project(s) found"
                }
            }
        }
    }
    
    // to get the list of queries accessible to the user
    func getQueries() {
        
        self.isFetchingWIT = true
        self.statusMessage = nil
        
        let prjBaseUrl: String = BASE_URL + self.organisation + "/" + self.project + "/_apis/wit/queries?$depth=1"
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(Queries.self, url: url, headers: self.header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isFetchingWIT = false
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    self.statusMessage = error.localizedDescription
                    
                case .success(let info):
                    if HTTP_DATA { print("Fetcher count: \(info.count)") }
                    
                    self.queries = info.value.sorted(by: {first,second in
                        return first.name < second.name
                    })
                    
                    for q in 0...(self.queries.count - 1) {
                        
                        self.printQuery(title: "ROOT", query: self.queries[q])
                        
                        if self.queries[q].children != nil { // must have children as this first query is on the root folder
                            
                            self.queries[q].children = self.queries[q].children!.sorted(by: {first,second in
                                return first.name < second.name
                            })
                            
                            for c in 0...(self.queries[q].children!.count - 1) { // already checked if array is not empty
                                
                                if self.queries[q].children![c].isFolder {
                                    
                                    self.printQuery(title: "GET CHILDREN", query: self.queries[q].children![c])
                                    
                                    self.getSubQueries(queryID: self.queries[q].children![c].id, completion: { query in
                                        
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
    
    func getSubQueries(queryID: String, completion: @escaping (QueryNode) -> Void) {
        
        self.isFetchingWIT = true
        
        let prjBaseUrl: String = BASE_URL + self.organisation + "/" + self.project + "/_apis/wit/queries/" + queryID + "?$depth=1"
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(QueryNode.self, url: url, headers: self.header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                //self.isLoading = false // moved to just before completion to avoid having the screen flashing
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    self.statusMessage = error.localizedDescription
                    
                    self.isFetchingWIT = false  // under test
                    
                    completion(QueryNode())
                    
                case .success(let info):
                    
                    if info.isFolder && info.children != nil {
                        
                        info.children = info.children!.sorted(by: {first,second in
                            return first.name < second.name
                        })
                        
                        for c in 0...(info.children!.count - 1) {
                            
                            if info.children![c].isFolder {
                                
                                if DEBUG_INFO { self.printQuery(title: "REC children", query: info.children![c]) }
                                
                                self.getSubQueries(queryID: info.children![c].id, completion: { query in
                                    
                                    if query.children != nil {
                                        info.children![c] = query
                                    }
                                })
                            }
                        }
                    }
                    
                    self.isFetchingWIT = false // under test
                    
                    completion(info)
                }
            }
        }
    }
    
    // to get the list of the most recent wits that the user has worked on (limited to 200)
    func getActivities() {
        
        self.isFetchingActivity = true
        self.statusMessage = nil
        
        let prjBaseUrl: String = BASE_URL + self.organisation + "/_apis/work/accountmyworkrecentactivity"
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(Activities.self, url: url, headers: self.header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isFetchingActivity = false
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    self.statusMessage = error.localizedDescription
                    
                case .success(let info):
                    if HTTP_DATA { print("Fetcher count: \(info.count)") }
                    
                    self.activities = info.value
                    
                    let reqURL: String = BASE_URL + self.organisation + "/" + self.project + "/_workitems/edit/"
                    
                    for activity in self.activities {
                        
                        // splitting between link and name to correctly display in dark mode
                        activity.idLink = "<a href=\"\(reqURL)\(activity.textID)\">\(activity.textID)</a>"
                    }
                    
                    self.statusMessage = "\(self.activities.count) activity(ies)"
                }
            }
        }
    }
    
    func getWit(witid: String) {
        
        self.getWits(ids: [witid])
    }
    
    fileprivate func sortByPriority() {
        if self.sortPriority { // sorting by priority
            
            self.wits = self.wits.sorted(by: {first,second in
                return first.fields.MicrosoftVSTSCommonPriority < second.fields.MicrosoftVSTSCommonPriority
            })
        }
    }
    
    fileprivate func createDisplayInfo(includeReport: Bool) -> String {
        
        let reqURL: String = BASE_URL + self.organisation + "/" + self.project + "/_workitems/edit/"
        
        var report: String = ""
        
        // create a link by project name and ID
        // create a link by ID
        // create html text with report
        for wit in self.wits {
            
            // splitting between link and name to correctly display in dark mode
            wit.projectLink = "<a href=\"\(reqURL)\(wit.textWitID)\">[\(self.project)-\(wit.textWitID)]</a>"
            
            wit.idLink = "<a href=\"\(reqURL)\(wit.textWitID)\">\(wit.textWitID)</a>"
            
            wit.html = wit.name + " " + wit.projectLink
            
            //add report field information if necessary
            if includeReport {
                
                wit.html += ": \(wit.fields.CustomReport)<br>"
                
            } else {
                
                wit.html += "<br>" // add line break if report is not added
            }
            
            report += wit.html
        }
        
        return report
    }
    
    fileprivate func copyToClipboard(_ report: String) {
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
    
    func getWits(ids: [String], cb: Bool = true, includeReport: Bool = true) {
        
        if ids.isEmpty { // if no ids in the list then simply return *** add some error handling ? ***
            
            self.statusMessage = "Query returned no results"
            
            self.wits.removeAll(keepingCapacity: true)
            
            return
        }
        
        self.isFetchingWIT = true
        self.statusMessage = nil
        
        self.wits.removeAll()
        
        // build id list limited to ADO_LIST_LIMIT = 200 wits
        var iStart: Int = 0
        var iEnd: Int = max(min(ids.count - 1, ADO_LIST_LIMIT - 1), 0) // cannot be less than zero, protection for the for block inside the batch in case the id list count at the top does not filter this error out
        let batches: Int = Int(ceil(Double(ids.count / ADO_LIST_LIMIT)))
        
        if DEBUG_INFO { print(batches) }
        
        for _ in 0...batches {
            
            var idList: String = String()
            
            for i in iStart...iEnd {
                
                idList += ids[i] + ","
            }
            
            iStart = iEnd + 1
            iEnd = min(ids.count - 1, iEnd + ADO_LIST_LIMIT)
            
            idList = idList.trimmingCharacters(in: [","])
            
            if DEBUG_INFO { print("Fetcher::wits \(idList)") }
            
            let witBaseUrl: String = BASE_URL + self.organisation + "/_apis/wit/workitems?ids=" + idList //"&$expand=all"
            
            let url = NSURL(string: witBaseUrl)! as URL
            
            self.service.fetch(Wits.self, url: url, headers: self.header) { [unowned self] result in
                
                DispatchQueue.main.async {
                    
                    self.isFetchingWIT = false
                    
                    switch result {
                    case .failure(let error):
                        if HTTP_ERROR { print("Fetcher error: \(error)") }
                        
                        self.statusMessage = error.localizedDescription
                        
                    case .success(let info):
                        if HTTP_DATA { print("Fetcher count: \(info.count)") }
                        
                        self.wits += info.value
                        
                        self.statusMessage = "Query returned \(self.wits.count) wit(s)"
                        
                        self.sortByPriority()
                        
                        let report: String = self.createDisplayInfo(includeReport: includeReport)
                        
                        if DEBUG_INFO { print(report) }
                        
                        // if query was for only one item or multiple items but 'add to clipboard' was selected
                        if self.wits.count == 1 {
                            
                            self.wit = self.wits.first!
                        }
                        
                        if cb {
                            self.copyToClipboard(report)
                        }
                    }
                }
            }
        }
    }
    
    // use a query id to get the list of wit ids and then use the wits fectcher function to get information for each wit
    func query(queryid: String, cb: Bool, addReport: Bool) {
        
        self.isFetchingWIT = true
        self.statusMessage = nil
        
        let prjBaseUrl: String = BASE_URL + self.organisation + "/_apis/wit/wiql?id=" + queryid
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(Query.self, url: url, headers: self.header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isFetchingWIT = false
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    self.statusMessage = error.localizedDescription
                    
                case .success(let info):
                    if HTTP_DATA { print("Fetcher count: \(info.workItems.count)") }
                    
                    self.query = info
                    
                    self.statusMessage = "Query returned  \(self.query.workItems.count) wit(s)"
                    
                    // build id list to query for the details on wits
                    var ids: [String] = [String]()
                    
                    for workItem in self.query.workItems {
                        ids.append(String(format: "%d", workItem.id))
                    }
                    
                    if DEBUG_INFO { print(ids) }
                    
                    // call wits function to get information about the wits
                    self.getWits(ids: ids, cb: cb, includeReport: addReport)
                }
            }
        }
    }
    
    func getWitLinks(id: Int) {
        
        self.isFetchingWIT = true
        self.statusMessage = nil
        
        self.fetched.removeAll()
        
        self.root = WitNode(witID: id)
        
        self.isFetchingWIT = true
        self.statusMessage = nil
        
        self.getWitLinks(node: self.root)
    }
    
    // queries for all the links contained in one wit
    func getWitLinks(node: WitNode) {
        
        let reqURL: String = BASE_URL + self.organisation + "/" + self.project + "/_workitems/edit/"
        
        // build the query url
        let witBaseUrl: String = BASE_URL + self.organisation + "/_apis/wit/workitems/" + "\(node.witID)" + "?$expand=relations"
        
        let url = NSURL(string: witBaseUrl)! as URL
        
        self.service.fetch(WitNode.self, url: url, headers: self.header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isFetchingWIT = false
                
                switch result {
                    
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    self.statusMessage = error.localizedDescription
                    
                case .success(let info):
                    if HTTP_DATA { print("Fetcher count: \([info].count)") }
                    
                    node.copy(from: info)
                    
                    node.idLink = "<a href=\"\(reqURL)\(node.textWitID)\">\(node.textWitID)</a>"
                    
                    if self.fetched.count >= ADO_TREE_LIMIT {
                        
                        self.statusMessage = "WARNING! \(ADO_TREE_LIMIT) wits limit reached"
                        
                        return
                    } else {
                        self.statusMessage = "Fetched \(self.fetched.count)"
                    }
                    
                    self.fetched.append(info.witID)
                    if DEBUG_INFO { print("fetched: \(self.fetched)") }
                    
                    for child in node.children ?? [] {
                        
                        if !self.fetched.contains(child.witID) && child.rel.rel != relation.file && child.rel.rel != relation.pullRequest {
                            
                            self.getWitLinks(node: child)
                        }
                    }
                }
            }
        }
    }
    
    func getUpdates(id: Int, completion: @escaping () -> Void) {
        
        self.isFetchingWIT = true
        self.statusMessage = nil
        
        //GET https://dev.azure.com/{organization}/{project}/_apis/wit/workItems/{id}/updates?api-version=7.0
        let prjBaseUrl: String = BASE_URL + self.organisation + "/_apis/wit/workItems/" + "\(id)" + "/updates?"
        
        let url = NSURL(string: prjBaseUrl)! as URL
        
        self.service.fetch(Updates.self, url: url, headers: self.header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isFetchingWIT = false
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR { print("Fetcher error: \(error)") }
                    
                    self.statusMessage = error.localizedDescription
                    
                case .success(let info):
                    if HTTP_DATA { print("Fetcher count: \(info.count)") }
                    
                    self.updates = info.value
                }
                
                completion()
            }
        }
    }
}
