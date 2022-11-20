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
        
        id = String()
        name = String()
        description = String()
        url = String()
        state = String()
        revision = 0
        visibility = String()
        lastUpdateTime = String()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.id = try values.decode(String.self, forKey: .id)
        } catch { self.id = String() }
        
        do { self.name = try values.decode(String.self, forKey: .name)
        } catch { self.name = String() }
        
        do { self.description = try values.decode(String.self, forKey: .description)
        } catch { self.description = String() }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = String() }
        
        do { self.state = try values.decode(String.self, forKey: .state)
        } catch { self.state = String() }
        
        do { self.revision = try values.decode(Int.self, forKey: .state)
        } catch { self.revision = Int() }
        
        do { self.visibility = try values.decode(String.self, forKey: .visibility)
        } catch { self.visibility = String() }
        
        do { self.lastUpdateTime = try values.decode(String.self, forKey: .lastUpdateTime)
        } catch { self.lastUpdateTime = String() }
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
        self.count = Int()
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

class Activity: Codable, Identifiable, Hashable {
    
    init() {
        id = Int()
        workItemType = String()
        title = String()
        state = String()
        changedDate = String()
        teamProject = String()
        activityDate = String()
        activityType = String()
        html = String()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.id = try values.decode(Int.self, forKey: .id)
        } catch { self.id = 0 }
        
        do { self.workItemType = try values.decode(String.self, forKey: .workItemType)
        } catch { self.workItemType = String() }
        
        do { self.title = try values.decode(String.self, forKey: .title)
        } catch { self.title = String() }
        
        do { self.state = try values.decode(String.self, forKey: .state)
        } catch { self.state = String() }
        
        do { self.changedDate = try values.decode(String.self, forKey: .changedDate)
        } catch { self.changedDate = String() }
        
        do { self.teamProject = try values.decode(String.self, forKey: .teamProject)
        } catch { self.teamProject = String() }
        
        do { self.activityDate = try values.decode(String.self, forKey: .activityDate)
        } catch { self.activityDate = String() }
        
        do { self.activityType = try values.decode(String.self, forKey: .activityType)
        } catch { self.activityType = String() }
        
        self.html = String() // to be filled later
    }
    
    // equatable
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id == rhs.id
    }
    
    // hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let workItemType: String
    let title: String
    let state: String
    let changedDate: String
    let teamProject: String
    let activityDate: String
    let activityType: String
    var html: String
}

class Wits: Codable, Identifiable {
    
    init() {
        self.value = [Wit]()
        self.count = Int()
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
        self.id = Int()
        self.fields = Fields()
        self.url = String()
        self.html = String()
        self.relations = [Relations]()
    }
    
    init(id: Int) {
        self.id = id
        self.fields = Fields()
        self.url = String()
        self.html = String()
        self.relations = [Relations]()
    }

    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.id = try values.decode(Int.self, forKey: .id)
        } catch { self.id = Int() }
        
        do { self.fields = try values.decode(Fields.self, forKey: .fields)
        } catch { self.fields = Fields() }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = String() }
        
        self.html = String() // to be filled later
        
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
    
    let id: Int
    let fields: Fields
    let url: String
    var html: String
    let relations: [Relations]
}

class WitNode: Wit, CustomStringConvertible {
    
    var description: String
    var children: [WitNode]?
    
    override init() {
        
        self.description = ""
        
        self.children = nil
        
        super.init()
    }

    init(id: Int, description: String) {
        
        self.description = description
        
        self.children = nil
        
        super.init(id: id)
    }
    
    required init(from decoder: Decoder) throws {
        
        self.description = ""
        
        self.children = nil
        
        try super.init(from: decoder)
        
        self.description = self.fields.SystemTitle
        
        if !relations.isEmpty {
            
            self.children = [WitNode]()
            
            for relation in relations {
                
                let child: WitNode = WitNode(id: relation.id, description: "\(relation.id)")
                                
                self.children?.append(child)
            }
        }
    }
}

class Fields: Codable, Identifiable {
    init() {
        self.SystemAreaPath = String()
        self.SystemTeamProject = String()
        self.SystemIterationPath = String()
        self.SystemWorkItemType = String()
        self.SystemState = String()
        self.SystemReason = String()
        self.SystemCreatedDate = String()
        self.SystemChangedDate = String()
        self.SystemTitle = String()
        self.SystemDescription = String()
        self.MicrosoftVSTSCommonPriority = Int()
        self.CustomReport = String()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.SystemAreaPath = try values.decode(String.self, forKey: .SystemAreaPath)
        } catch { self.SystemAreaPath = String() }
        
        do { self.SystemTeamProject = try values.decode(String.self, forKey: .SystemTeamProject)
        } catch { self.SystemTeamProject = String() }
        
        do { self.SystemIterationPath = try values.decode(String.self, forKey: .SystemIterationPath)
        } catch { self.SystemIterationPath = String() }
        
        do { self.SystemWorkItemType = try values.decode(String.self, forKey: .SystemWorkItemType)
        } catch { self.SystemWorkItemType = String() }
        
        do { self.SystemState = try values.decode(String.self, forKey: .SystemState)
        } catch { self.SystemState = String() }
        
        do { self.SystemReason = try values.decode(String.self, forKey: .SystemReason)
        } catch { self.SystemReason = String() }
        
        do { self.SystemCreatedDate = try values.decode(String.self, forKey: .SystemCreatedDate)
        } catch { self.SystemCreatedDate = String() }
        
        do { self.SystemChangedDate = try values.decode(String.self, forKey: .SystemChangedDate)
        } catch { self.SystemChangedDate = String() }
        
        do { self.SystemTitle = try values.decode(String.self, forKey: .SystemTitle)
        } catch { self.SystemTitle = String() }
        
        do { self.SystemDescription = try values.decode(String.self, forKey: .SystemDescription)
        } catch { self.SystemDescription = String() }
        
        do { self.MicrosoftVSTSCommonPriority = try values.decode(Int.self, forKey: .MicrosoftVSTSCommonPriority)
        } catch { self.MicrosoftVSTSCommonPriority = Int() }
        
        // trimming added to remove leading and trailing white spaces and new lines
        
        var report: String = String()
        
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
        } catch { self.rel = String() }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = String() }
        
        do { self.attributes = try values.decode(Attributes.self, forKey: .attributes)
        } catch { self.attributes = Attributes() }
        
        // using values retrieved above
        switch self.rel {
        case relations.related.rawValue:
            self.id = getWitNumber(url: self.url)
        case relations.file.rawValue:
            self.id = self.attributes.id
        default:
            self.id = 0
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
        } catch { self.name = String() }
        
        do { self.id = try values.decode(Int.self, forKey: .id)
        } catch { self.id = Int() }
    }
    
    let isLocked: Bool
    let id: Int
    let name: String
}

class Query: Codable, Identifiable, Hashable {
    
    init() {
        queryType = String()
        queryResultType = String()
        asOf = String()
        columns = [Column]()
        workItems = [WorkItem]()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.queryType = try values.decode(String.self, forKey: .queryType)
        } catch { self.queryType = String() }
        
        do { self.queryResultType = try values.decode(String.self, forKey: .queryResultType)
        } catch { self.queryResultType = String() }
        
        do { self.asOf = try values.decode(String.self, forKey: .asOf)
        } catch { self.asOf = String() }
        
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
        self.referenceName = String()
        self.name = String()
        self.url = String()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.referenceName = try values.decode(String.self, forKey: .referenceName)
        } catch { self.referenceName = String() }
        
        do { self.name = try values.decode(String.self, forKey: .name)
        } catch { self.name = String() }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = String() }
    }
    
    let referenceName: String
    let name: String
    let url: String
}

class WorkItem: Codable, Identifiable {
    
    init() {
        self.id = Int()
        self.url = String()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.id = try values.decode(Int.self, forKey: .id)
        } catch { self.id = Int() }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = String() }
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
        id = String()
        name = String()
        path = String()
        createdDate = String()
        lastModifiedDate = String()
        isFolder = Bool()
        hasChildren = Bool()
        children = nil
        queryType = String()
        isPublic = Bool()
        lastExecutedDate = String()
        _links = Links()
        url = String()
        
        description = isFolder ? "📂 \(name)" : "📄 \(name)"
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.id = try values.decode(String.self, forKey: .id)
        } catch { self.id = String() }
        
        do { self.name = try values.decode(String.self, forKey: .name)
        } catch { self.name = String() }
        
        do { self.path = try values.decode(String.self, forKey: .path)
        } catch { self.path = String() }
        
        do { self.createdDate = try values.decode(String.self, forKey: .createdDate)
        } catch { self.createdDate = String() }
        
        do { self.lastModifiedDate = try values.decode(String.self, forKey: .lastModifiedDate)
        } catch { self.lastModifiedDate = String() }
        
        do { self.isFolder = try values.decode(Bool.self, forKey: .isFolder)
        } catch { self.isFolder = Bool() }
        
        do { self.hasChildren = try values.decode(Bool.self, forKey: .id)
        } catch { self.hasChildren = Bool() }
        
        do { self.children = try values.decode([QueryNode].self, forKey: .children)
        } catch { self.children = nil }
        
        do { self.queryType = try values.decode(String.self, forKey: .queryType)
        } catch { self.queryType = String() }
        
        do { self.isPublic = try values.decode(Bool.self, forKey: .isPublic)
        } catch { self.isPublic = Bool() }
        
        do { self.lastExecutedDate = try values.decode(String.self, forKey: .lastExecutedDate)
        } catch { self.lastExecutedDate = String() }
        
        do { self._links = try values.decode(Links.self, forKey: ._links)
        } catch { self._links = Links() }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = String() }
        
        description = isFolder ? "📂 \(name)" : "📄 \(name)"
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
    let children: [QueryNode]?
    let queryType: String
    let isPublic: Bool
    let lastExecutedDate: String
    let _links: Links
    let url: String
    var description: String
}

class Link: Codable {
    
    init() {
        href = String()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.href = try values.decode(String.self, forKey: .href)
        } catch { self.href = String() }
        
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
