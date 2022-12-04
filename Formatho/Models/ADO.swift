//
//  ADO.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 18/9/22.
//

import Foundation

class Projects: Codable, Identifiable {
    
    init() {
        self.value = [Project]()
        self.count = 0
    }
    
    let value: [Project]
    let count: Int
}

class Project: Codable, Identifiable, Hashable {
    
    init() {
        
        id = ""
        name = ""
        description = ""
        url = ""
        state = ""
        revision = 0
        visibility = ""
        lastUpdateTime = ""
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.id = try values.decode(String.self, forKey: .id)
        } catch { self.id = "" }
        
        do { self.name = try values.decode(String.self, forKey: .name)
        } catch { self.name = "" }
        
        do { self.description = try values.decode(String.self, forKey: .description)
        } catch { self.description = "" }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = "" }
        
        do { self.state = try values.decode(String.self, forKey: .state)
        } catch { self.state = "" }
        
        do { self.revision = try values.decode(Int.self, forKey: .state)
        } catch { self.revision = 0 }
        
        do { self.visibility = try values.decode(String.self, forKey: .visibility)
        } catch { self.visibility = "" }
        
        do { self.lastUpdateTime = try values.decode(String.self, forKey: .lastUpdateTime)
        } catch { self.lastUpdateTime = "" }
    }
    
    // equatable
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.id == rhs.id
    }
    
    // hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String
    let name: String
    let description: String
    let url: String
    let state: String
    let revision: Int
    let visibility: String
    let lastUpdateTime: String
}

class Activities: Codable, Identifiable {
    
    init() {
        self.value = [Activity]()
        self.count = 0
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.value = try values.decode([Activity].self, forKey: .value)
        } catch { self.value = [Activity]() }
        
        do { self.count = try values.decode(Int.self, forKey: .count)
        } catch { self.count = 0 }
    }
    
    let value: [Activity]
    let count: Int
}

class Activity: Codable, Identifiable, Hashable, Equatable {
    
    init() {
        activityID = 0
        textID = ""
        workItemType = ""
        title = ""
        state = ""
        changedDate = ""
        teamProject = ""
        activityDate = ""
        activityType = ""
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.activityID = try values.decode(Int.self, forKey: .activityID)
        } catch { self.activityID = 0 }
        
        self.textID = "\(self.activityID)"
        
        do { self.workItemType = try values.decode(String.self, forKey: .workItemType)
        } catch { self.workItemType = "" }
        
        do { self.title = try values.decode(String.self, forKey: .title)
        } catch { self.title = "" }
        
        do { self.state = try values.decode(String.self, forKey: .state)
        } catch { self.state = "" }
        
        do { self.changedDate = try values.decode(String.self, forKey: .changedDate)
        } catch { self.changedDate = "" }
        
        do { self.teamProject = try values.decode(String.self, forKey: .teamProject)
        } catch { self.teamProject = "" }
        
        do { self.activityDate = try values.decode(String.self, forKey: .activityDate)
        } catch { self.activityDate = "" }
        
        do { self.activityType = try values.decode(String.self, forKey: .activityType)
        } catch { self.activityType = "" }
    }
    
    enum CodingKeys: String, CodingKey {
        case activityID = "id"
        case workItemType = "workItemType"
        case title = "title"
        case state = "state"
        case changedDate = "changedDate"
        case teamProject = "teamProject"
        case activityDate = "activityDate"
        case activityType = "activityType"
    }
    
    // equatable
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id == rhs.id
    }
    
    // hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id = UUID()
    let activityID: Int
    let textID: String
    let workItemType: String
    let title: String
    let state: String
    let changedDate: String
    let teamProject: String
    let activityDate: String
    let activityType: String
}

class Wits: Codable, Identifiable {
    
    init() {
        self.value = [Wit]()
        self.count = 0
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.value = try values.decode([Wit].self, forKey: .value)
        } catch { self.value = [Wit]() }
        
        do { self.count = try values.decode(Int.self, forKey: .count)
        } catch { self.count = 0 }
    }
    
    let value: [Wit]
    let count: Int
}

class Wit: Codable, Identifiable, Hashable {
    
    init() {
        self.witID = 0
        self.textWitID = ""
        self.fields = Fields()
        self.url = ""
        self.name = ""
        self.link = ""
        self.html = ""
        self.relations = [Relations]()
    }
    
    init(witID: Int) {
        self.witID = witID
        self.textWitID = "\(self.witID)"
        self.fields = Fields()
        self.url = ""
        self.name = ""
        self.link = ""
        self.html = ""
        self.relations = [Relations]()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.witID = try values.decode(Int.self, forKey: .witID)
        } catch { self.witID = 0 }
        
        self.textWitID = "\(self.witID)"
        
        do { self.fields = try values.decode(Fields.self, forKey: .fields)
        } catch { self.fields = Fields() }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = "" }
        
        self.name = "<b>\(self.fields.textPriority) \(self.fields.SystemWorkItemType) \(self.fields.SystemTitle)</b>"
        
        self.link = ""
        
        self.html = ""
        
        do { self.relations = try values.decode([Relations].self, forKey: .relations)
        } catch { self.relations = [Relations]() }
    }
    
    // equatable
    static func == (lhs: Wit, rhs: Wit) -> Bool {
        return lhs.id == rhs.id
    }
    
    // hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case witID = "id"
        case fields = "fields"
        case url = "url"
        case relations = "relations"
    }
    
    let witID: Int
    let textWitID: String
    let fields: Fields
    let url: String
    var name: String // wit name in html format
    var link: String // link in html format
    var html: String // full html formatted wit
    let relations: [Relations]
    let id = UUID()
}

class WitNode: Wit, CustomStringConvertible {
    
    var description: String
    var children: [WitNode]?
    var nodeType: relation
    
    override init() {
        
        self.description = ""
        self.children = nil
        self.nodeType = relation.root
        
        super.init()
    }
    
    init(witID: Int, description: String, nodeType: relation) {
        
        self.description = description
        
        self.children = nil
        
        self.nodeType = nodeType
        
        super.init(witID: witID)
    }
    
    required init(from decoder: Decoder) throws {
        
        self.description = ""
        
        self.children = nil
        
        self.nodeType = relation.root
        
        try super.init(from: decoder)
        
        self.description = "\(self.textWitID): " + self.fields.SystemTitle + ": " + self.fields.SystemState
        
        if !relations.isEmpty {
            
            self.children = [WitNode]()
            
            for rel in relations { // list for relation class
                
                var bFound = false
                
                for child in self.children ?? [] { // check if it's a duplicate
                    
                    if child.witID == rel.id {
                        
                        if DEBUG_INFO { print("DUPLICATE: \(rel.id)") }
                        
                        bFound = true
                        break
                    }
                }
                
                if !bFound { // do not add duplicate ids to the hierarchy
                    
                    var nodeType: relation
                    
                    var tempChild: WitNode
                    
                    switch rel.rel {
                    case relation.related.rawValue:
                        nodeType = relation.related
                        
                    case relation.child.rawValue:
                        nodeType = relation.child
                        
                    case relation.parent.rawValue:
                        nodeType = relation.parent

                    case relation.predecessor.rawValue:
                        nodeType = relation.predecessor
                    
                    case relation.pullRequest.rawValue:
                        nodeType = relation.pullRequest
                        
                    case relation.file.rawValue:
                        nodeType = relation.file

                    default:
                        nodeType = relation.root
                    }
                    
                    switch nodeType {
                    case relation.file, relation.pullRequest:
                        tempChild = WitNode(witID: rel.id, description: "\(nodeType.rawValue): \(rel.attributes.name): \(rel.id)", nodeType: nodeType)
                        
                    default:
                        tempChild = WitNode(witID: rel.id, description: "\(rel.attributes.name): \(rel.id)", nodeType: nodeType)
                    }
                    
                    let child: WitNode = tempChild
                    
                    self.children?.append(child)
                }
            }
        }
    }
}

class Fields: Codable, Identifiable {
    init() {
        self.SystemAreaPath = ""
        self.SystemTeamProject = ""
        self.SystemIterationPath = ""
        self.SystemWorkItemType = ""
        self.SystemState = ""
        self.SystemReason = ""
        self.SystemCreatedDate = ""
        self.SystemChangedDate = ""
        self.SystemTitle = ""
        self.SystemDescription = ""
        self.MicrosoftVSTSCommonPriority = 0
        self.textPriority = ""
        self.CustomReport = ""
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.SystemAreaPath = try values.decode(String.self, forKey: .SystemAreaPath)
        } catch { self.SystemAreaPath = "" }
        
        do { self.SystemTeamProject = try values.decode(String.self, forKey: .SystemTeamProject)
        } catch { self.SystemTeamProject = "" }
        
        do { self.SystemIterationPath = try values.decode(String.self, forKey: .SystemIterationPath)
        } catch { self.SystemIterationPath = "" }
        
        do { self.SystemWorkItemType = try values.decode(String.self, forKey: .SystemWorkItemType)
        } catch { self.SystemWorkItemType = "" }
        
        do { self.SystemState = try values.decode(String.self, forKey: .SystemState)
        } catch { self.SystemState = "" }
        
        do { self.SystemReason = try values.decode(String.self, forKey: .SystemReason)
        } catch { self.SystemReason = "" }
        
        do { self.SystemCreatedDate = try values.decode(String.self, forKey: .SystemCreatedDate)
        } catch { self.SystemCreatedDate = "" }
        
        do { self.SystemChangedDate = try values.decode(String.self, forKey: .SystemChangedDate)
        } catch { self.SystemChangedDate = "" }
        
        do { self.SystemTitle = try values.decode(String.self, forKey: .SystemTitle)
        } catch { self.SystemTitle = "" }
        
        do { self.SystemDescription = try values.decode(String.self, forKey: .SystemDescription)
        } catch { self.SystemDescription = "" }
        
        do { self.MicrosoftVSTSCommonPriority = try values.decode(Int.self, forKey: .MicrosoftVSTSCommonPriority)
        } catch { self.MicrosoftVSTSCommonPriority = 0 }
        
        self.textPriority = "P\(self.MicrosoftVSTSCommonPriority)"
        
        // trimming added to remove leading and trailing white spaces and new lines
        
        var report: String
        
        do {
            // remove leading and trailing div on report field
            report = try values.decode(String.self, forKey: .CustomReport).trimmingCharacters(in: .whitespacesAndNewlines)
            
            if report.hasPrefix("<div>") { report = String(report.dropFirst(5)) }
            
            if report.hasSuffix("</div>") { report = String(report.dropLast(6)) }
            
            report = report.trimmingCharacters(in: .whitespacesAndNewlines)
            
            self.CustomReport = report
            
        } catch { self.CustomReport = "" }
    }
    
    enum CodingKeys: String, CodingKey {
        case SystemAreaPath = "System.AreaPath"
        case SystemTeamProject = "System.TeamProject"
        case SystemIterationPath = "System.IterationPath"
        case SystemWorkItemType = "System.WorkItemType"
        case SystemState = "System.State"
        case SystemReason = "System.Reason"
        case SystemCreatedDate = "System.CreatedDate"
        case SystemChangedDate = "System.ChangedDate"
        case SystemTitle = "System.Title"
        case SystemDescription = "System.Description"
        case MicrosoftVSTSCommonPriority = "Microsoft.VSTS.Common.Priority"
        case CustomReport = "Custom.Report"
    }
    
    let SystemAreaPath: String
    let SystemTeamProject: String
    let SystemIterationPath: String
    let SystemWorkItemType: String
    let SystemState: String
    let SystemReason: String
    let SystemCreatedDate: String
    let SystemChangedDate: String
    let SystemTitle: String
    let SystemDescription: String
    let MicrosoftVSTSCommonPriority: Int
    let textPriority: String
    let CustomReport: String
}

class Relations: Codable, Identifiable, Hashable {
    
    init() {
        self.id = 0
        self.rel = ""
        self.url = ""
        self.attributes = Attributes()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.rel = try values.decode(String.self, forKey: .rel)
        } catch { self.rel = "" }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = "" }
        
        do { self.attributes = try values.decode(Attributes.self, forKey: .attributes)
        } catch { self.attributes = Attributes() }
        
        // using values retrieved above populate the id and the relation type enum
        switch self.rel {
        case relation.file.rawValue, relation.pullRequest.rawValue:
            self.id = self.attributes.id
            
        default:
            self.id = getWitNumber(url: self.url)
        }
    }
    
    // equatable
    static func == (lhs: Relations, rhs: Relations) -> Bool {
        return lhs.id == rhs.id
    }
    
    // hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: Int
    let rel: String
    let url: String
    let attributes: Attributes
}

class Attributes: Codable, Identifiable {
    
    init() {
        self.isLocked = false
        self.id = 0
        self.name = ""
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.isLocked = try values.decode(Bool.self, forKey: .isLocked)
        } catch { self.isLocked = Bool() }
        
        do { self.name = try values.decode(String.self, forKey: .name)
        } catch { self.name = "" }
        
        do { self.id = try values.decode(Int.self, forKey: .id)
        } catch { self.id = 0 }
    }
    
    let isLocked: Bool
    let id: Int
    let name: String
}

class Query: Codable, Identifiable, Hashable {
    
    init() {
        queryType = ""
        queryResultType = ""
        asOf = ""
        columns = [Column]()
        workItems = [WorkItem]()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.queryType = try values.decode(String.self, forKey: .queryType)
        } catch { self.queryType = "" }
        
        do { self.queryResultType = try values.decode(String.self, forKey: .queryResultType)
        } catch { self.queryResultType = "" }
        
        do { self.asOf = try values.decode(String.self, forKey: .asOf)
        } catch { self.asOf = "" }
        
        do { self.columns = try values.decode([Column].self, forKey: .columns)
        } catch { self.columns = [Column]() }
        
        do { self.workItems = try values.decode([WorkItem].self, forKey: .workItems)
        } catch { self.workItems = [WorkItem]() }
    }
    
    // equatable
    static func == (lhs: Query, rhs: Query) -> Bool {
        return lhs.asOf == rhs.asOf
    }
    
    // hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let queryType: String
    let queryResultType: String
    let asOf: String
    let columns: [Column]
    let workItems: [WorkItem]
}

class Column: Codable, Identifiable {
    
    init() {
        self.referenceName = ""
        self.name = ""
        self.url = ""
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.referenceName = try values.decode(String.self, forKey: .referenceName)
        } catch { self.referenceName = "" }
        
        do { self.name = try values.decode(String.self, forKey: .name)
        } catch { self.name = "" }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = "" }
    }
    
    let referenceName: String
    let name: String
    let url: String
}

class WorkItem: Codable, Identifiable {
    
    init() {
        self.id = 0
        self.url = ""
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.id = try values.decode(Int.self, forKey: .id)
        } catch { self.id = 0 }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = "" }
    }
    
    let id: Int
    let url: String
}

class Queries: Codable, Identifiable {
    
    init() {
        self.value = [QueryNode]()
        self.count = 0
    }
    
    let value: [QueryNode]
    let count: Int
}

class QueryNode: Codable, Identifiable, Hashable, CustomStringConvertible {
    
    init() {
        id = ""
        name = ""
        path = ""
        createdDate = ""
        lastModifiedDate = ""
        isFolder = Bool()
        hasChildren = Bool()
        children = nil
        queryType = ""
        isPublic = Bool()
        lastExecutedDate = ""
        _links = Links()
        url = ""
        
        description = isFolder ? "📂 \(name)" : "📄 \(name)"
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.id = try values.decode(String.self, forKey: .id)
        } catch { self.id = "" }
        
        do { self.name = try values.decode(String.self, forKey: .name)
        } catch { self.name = "" }
        
        do { self.path = try values.decode(String.self, forKey: .path)
        } catch { self.path = "" }
        
        do { self.createdDate = try values.decode(String.self, forKey: .createdDate)
        } catch { self.createdDate = "" }
        
        do { self.lastModifiedDate = try values.decode(String.self, forKey: .lastModifiedDate)
        } catch { self.lastModifiedDate = "" }
        
        do { self.isFolder = try values.decode(Bool.self, forKey: .isFolder)
        } catch { self.isFolder = Bool() }
        
        do { self.hasChildren = try values.decode(Bool.self, forKey: .id)
        } catch { self.hasChildren = Bool() }
        
        do { self.children = try values.decode([QueryNode].self, forKey: .children)
        } catch { self.children = nil }
        
        do { self.queryType = try values.decode(String.self, forKey: .queryType)
        } catch { self.queryType = "" }
        
        do { self.isPublic = try values.decode(Bool.self, forKey: .isPublic)
        } catch { self.isPublic = Bool() }
        
        do { self.lastExecutedDate = try values.decode(String.self, forKey: .lastExecutedDate)
        } catch { self.lastExecutedDate = "" }
        
        do { self._links = try values.decode(Links.self, forKey: ._links)
        } catch { self._links = Links() }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = "" }
        
        description = "\(name)"
    }
    
    // equatable
    static func == (lhs: QueryNode, rhs: QueryNode) -> Bool {
        return lhs.id == rhs.id
    }
    
    // hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String
    let name: String
    let path: String
    let createdDate: String
    let lastModifiedDate: String
    let isFolder: Bool
    let hasChildren: Bool
    var children: [QueryNode]?
    let queryType: String
    let isPublic: Bool
    let lastExecutedDate: String
    let _links: Links
    let url: String
    var description: String
}

class Link: Codable {
    
    init() {
        href = ""
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.href = try values.decode(String.self, forKey: .href)
        } catch { self.href = "" }
        
    }
    
    let href: String
}

class Links: Codable {
    
    init() {
        lSelf = Link()
        html = Link()
        parent = Link()
        wiql = Link()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.lSelf = try values.decode(Link.self, forKey: .lSelf)
        } catch { self.lSelf = Link() }
        
        do { self.html = try values.decode(Link.self, forKey: .html)
        } catch { self.html = Link() }
        
        do { self.parent = try values.decode(Link.self, forKey: .parent)
        } catch { self.parent = Link() }
        
        do { self.wiql = try values.decode(Link.self, forKey: .wiql)
        } catch { self.wiql = Link() }
    }
    
    enum CodingKeys: String, CodingKey {
        case lSelf = "self"
        case html = "html"
        case parent = "parent"
        case wiql = "wiql"
    }
    
    let lSelf: Link
    let html: Link
    let parent: Link
    let wiql: Link
}
