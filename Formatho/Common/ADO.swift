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
        idLink = ""
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
        
        idLink = ""
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
    var idLink: String
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
        self.projectLink = ""
        self.idLink = ""
        self.html = ""
        self.relations = [Relations]()
    }
    
    init(from: Wit) {
        
        self.witID = from.witID
        self.textWitID = from.textWitID
        self.fields = from.fields
        self.url = from.url
        self.projectLink = from.projectLink
        self.idLink = from.idLink
        self.html = from.html
        self.relations = from.relations
    }
    
    init(witID: Int) {
        self.witID = witID
        self.textWitID = "\(self.witID)"
        self.fields = Fields()
        self.url = ""
        self.projectLink = ""
        self.idLink = ""
        self.html = ""
        self.relations = [Relations]()
    }
    
    // new constructor for widget placeholder and snapshot
    init(witID: Int, fields: Fields) {
        self.witID = witID
        self.textWitID = "\(self.witID)"
        self.fields = fields
        self.url = ""
        self.projectLink = ""
        self.idLink = ""
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
        
        self.projectLink = ""
        
        self.idLink = "" // <a href=\"\(self.url)\">\(self.textWitID)</a>" this URL points to the JSON
        
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
    
    func formatted(html: Bool) -> String {
        
        var formattedString: String = "\(self.fields.textPriority) \(self.fields.SystemWorkItemType) \(self.fields.SystemTitle)"
            
        if !self.fields.CustomRequestor.isEmpty { // if there's a requestor string then add it to the beginning
            
            formattedString = "\(self.fields.CustomRequestor) - \(formattedString)"
        }
        
        if html { // if html then add the bold markers
            
            if self.fields.CustomRequestor.isEmpty { // in case there is no requestor string
                
                formattedString = "<b>\(formattedString)</b>"
            }
        }
        
        return formattedString
    }
    
    func copy(from: Wit) {
        
        self.witID = from.witID
        self.textWitID = from.textWitID
        self.fields = from.fields
        self.url = from.url
        self.projectLink = from.projectLink
        self.idLink = from.idLink
        self.html = from.html
        self.relations = from.relations
    }
    
    func copy() -> Wit {
        
        return Wit(from: self)
    }
    
    var witID: Int
    var textWitID: String
    var fields: Fields
    var url: String
    var projectLink: String // project-id link in html format
    var idLink: String // id link in html format
    var html: String // full html formatted wit
    var relations: [Relations]
    let id = UUID()
}

class Updates: Codable, Identifiable {
    
    init() {
        self.value = [Update]()
        self.count = 0
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.value = try values.decode([Update].self, forKey: .value)
        } catch { self.value = [Update]() }
        
        do { self.count = try values.decode(Int.self, forKey: .count)
        } catch { self.count = 0 }
    }
    
    let value: [Update]
    let count: Int
}

class Update: Codable, Identifiable, Hashable {
    
    init() {
        self.updateID = 0
        self.workItemId = 0
        self.rev = 0
        self.revisedBy = User()
        self.revisedDate = Date()
        self.fields = FieldsUpdate()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        
        do { self.updateID = try values.decode(Int.self, forKey: .updateID)
        } catch { self.updateID = 0 }
        
        do { self.workItemId = try values.decode(Int.self, forKey: .workItemId)
        } catch { self.workItemId = 0 }
        
        do { self.rev = try values.decode(Int.self, forKey: .rev)
        } catch { self.rev = 0 }
        
        do { self.revisedBy = try values.decode(User.self, forKey: .revisedBy)
        } catch { self.revisedBy = User() }
        
        do {
            self.revisedDate = dateFormatter.date(from: try values.decode(String.self, forKey: .revisedDate)) ?? Date()
            
            //print("revisedDate: \(self.revisedDate.formatted())")
        } catch { self.revisedDate = Date() }
        
        do { self.fields = try values.decode(FieldsUpdate.self, forKey: .fields)
        } catch { self.fields = FieldsUpdate() }
    }
    
    // equatable
    static func == (lhs: Update, rhs: Update) -> Bool {
        return lhs.id == rhs.id
    }
    
    // hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case updateID = "id"
        case workItemId = "workItemId"
        case rev = "rev"
        case revisedBy = "revisedBy"
        case revisedDate = "revisedDate"
        case fields = "fields"
    }
    
    let updateID: Int
    let workItemId: Int
    let rev: Int
    let revisedBy: User
    let revisedDate: Date
    let fields: FieldsUpdate
    
    let id = UUID()
    
    let dateFormatter = DateFormatter()
}

class FieldsUpdate: Codable, Identifiable {
    
    init() {
        
        SystemRevisedDate = DateField()
        CustomReport = StringField()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.CustomReport = try values.decode(StringField.self, forKey: .CustomReport)
            
            //print("FieldsUpdate:CustomReport oldValue: \(self.CustomReport.oldValue)")
            //print("FieldsUpdate:CustomReport newValue: \(self.CustomReport.newValue)")
        } catch { self.CustomReport = StringField() }
        
        do {
            self.SystemRevisedDate = try values.decode(DateField.self, forKey: .SystemRevisedDate)
            
            //print("FieldsUpdate:SystemRevisedDate oldValue: \(self.SystemRevisedDate.oldValue.formatted())")
            //print("FieldsUpdate:SystemRevisedDate newValue: \(self.SystemRevisedDate.newValue.formatted())")
            
        } catch { self.SystemRevisedDate = DateField() }
    }
    
    enum CodingKeys: String, CodingKey {
        case SystemRevisedDate = "System.RevisedDate"
        case CustomReport = "Custom.Report"
    }
    
    let SystemRevisedDate: DateField
    let CustomReport: StringField
    
    let id = UUID()
}

class StringField: Codable, Identifiable {
    
    init() {
        
        oldValue = ""
        newValue = ""
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.oldValue = try values.decode(String.self, forKey: .oldValue)
        } catch { self.oldValue = "" }
        
        do { self.newValue = try values.decode(String.self, forKey: .newValue)
        } catch { self.newValue = "" }
    }
    
    enum CodingKeys: String, CodingKey {
        case oldValue = "oldValue"
        case newValue = "newValue"
    }
    
    let oldValue: String
    let newValue: String
    
    let id = UUID()
}

class DateField: Codable, Identifiable {
    
    init() {
        
        oldValue = Date()
        newValue = Date()
    }
    
    required init(from decoder: Decoder) throws {
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.oldValue = dateFormatter.date(from: try values.decode(String.self, forKey: .oldValue)) ?? Date()
        } catch { self.oldValue = Date() }
        
        do { self.newValue = dateFormatter.date(from: try values.decode(String.self, forKey: .newValue)) ?? Date()
        } catch { self.newValue = Date() }
    }
    
    enum CodingKeys: String, CodingKey {
        case oldValue = "oldValue"
        case newValue = "newValue"
    }
    
    let oldValue: Date
    let newValue: Date
    
    let id = UUID()
    
    let dateFormatter = DateFormatter()
}


class WitNode: Wit {
    
    override init() {
        
        self.description = ""
        self.children = nil
        self.rel = Relations()
        
        super.init()
    }
    
    override init(witID: Int) {
        
        self.description = ""
        self.children = nil
        self.rel = Relations()
        
        super.init(witID: witID)
    }
    
    init(relations: Relations) {
        
        self.description = ""
        
        self.rel = relations
                
        self.children = nil
        
        super.init(witID: relations.id)
        
        switch self.rel.rel {
            
        case relation.file, relation.pullRequest:
            self.description = "\(self.rel.id): \(self.rel.attributes.name)"
            
        default:
            self.description = self.formatted(html: false) //"\(self.rel.id)"
        }
    }
    
    required init(from decoder: Decoder) throws {
        
        self.description = ""
        
        self.rel = Relations()
        
        self.children = [WitNode]()
        
        try super.init(from: decoder)
        
        self.description = self.fields.SystemTitle + ": " + self.fields.SystemState
            
        for rel in relations { // list for relation class
            
            var bFound = false
            
            for child in children ?? [] {
                if child.witID == rel.id {
                    
                    if DEBUG_INFO { print("DUPLICATE: \(rel.id)") }
                    
                    bFound = true
                    
                    break
                }
            }
            
            if !bFound { // do not add duplicate ids to the hierarchy
                
                self.children?.append(WitNode(relations: rel))
            }
        }
    }
    
    func copy(from: WitNode) {
        
        self.description = from.description
        self.rel = from.rel
        self.children = from.children
        
        super.copy(from: from)
    }
    
    var description: String
    var children: [WitNode]?
    var rel: Relations
}

class Fields: Codable, Identifiable {
    init() {
        self.SystemAreaPath = ""
        self.SystemTeamProject = ""
        self.SystemIterationPath = ""
        self.SystemWorkItemType = ""
        self.SystemState = ""
        self.SystemReason = ""
        self.SystemAssignedTo = User()
        self.SystemCreatedDate = Date()
        self.SystemCreatedBy = User()
        self.SystemChangedDate = Date()
        self.SystemChangedBy = User()
        self.SystemCommentCount = 0
        self.SystemTitle = ""
        self.CustomRequestor = ""
        self.SystemDescription = ""
        self.MicrosoftVSTSCommonPriority = 0
        self.textPriority = ""
        self.CustomReport = ""
    }
    
    // new constructor for widget placeholder and snapshot
    init(areaPath: String, workItemType: String, state: String, assignedTo: User, commentCount: Int, title: String, requestor: String, priority: Int) {
        self.SystemAreaPath = areaPath
        self.SystemTeamProject = ""
        self.SystemIterationPath = ""
        self.SystemWorkItemType = workItemType
        self.SystemState = state
        self.SystemReason = ""
        self.SystemAssignedTo = assignedTo
        self.SystemCreatedDate = Date()
        self.SystemCreatedBy = User()
        self.SystemChangedDate = Date()
        self.SystemChangedBy = User()
        self.SystemCommentCount = commentCount
        self.SystemTitle = title
        self.CustomRequestor = requestor
        self.SystemDescription = ""
        self.MicrosoftVSTSCommonPriority = priority
        self.textPriority = "P\(self.MicrosoftVSTSCommonPriority)"
        self.CustomReport = ""
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        
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
        
        do { self.SystemAssignedTo = try values.decode(User.self, forKey: .SystemAssignedTo)
        } catch { self.SystemAssignedTo = User() }
        
        do { self.SystemCreatedDate = dateFormatter.date(from: try values.decode(String.self, forKey: .SystemCreatedDate)) ?? Date()
        } catch { self.SystemCreatedDate = Date() }
        
        do { self.SystemCreatedBy = try values.decode(User.self, forKey: .SystemCreatedBy)
        } catch { self.SystemCreatedBy = User() }
        
        do { self.SystemChangedDate = dateFormatter.date(from: try values.decode(String.self, forKey: .SystemChangedDate)) ?? Date()
        } catch { self.SystemChangedDate = Date() }
        
        do { self.SystemChangedBy = try values.decode(User.self, forKey: .SystemChangedBy)
        } catch { self.SystemChangedBy = User() }
        
        do { self.SystemCommentCount = try values.decode(Int.self, forKey: .SystemCommentCount)
        } catch { self.SystemCommentCount = 0 }
        
        do { self.SystemTitle = try values.decode(String.self, forKey: .SystemTitle)
        } catch { self.SystemTitle = "" }
        
        do { self.CustomRequestor = try values.decode(String.self, forKey: .CustomRequestor)
        } catch { self.CustomRequestor = "" }
        
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
        case SystemAssignedTo = "System.AssignedTo"
        case SystemCreatedDate = "System.CreatedDate"
        case SystemCreatedBy = "System.CreatedBy"
        case SystemChangedDate = "System.ChangedDate"
        case SystemChangedBy = "System.ChangedBy"
        case SystemCommentCount = "System.CommentCount"
        case SystemTitle = "System.Title"
        case CustomRequestor = "Custom.Requestor"
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
    let SystemAssignedTo: User
    let SystemCreatedDate: Date
    let SystemCreatedBy: User
    let SystemChangedDate: Date
    let SystemChangedBy: User
    let SystemCommentCount: Int
    let SystemTitle: String
    let CustomRequestor: String
    let SystemDescription: String
    let MicrosoftVSTSCommonPriority: Int
    let textPriority: String
    let CustomReport: String
    
    let dateFormatter = DateFormatter()
}

class User: Codable, Identifiable {
    init() {
        self.displayName = ""
        self.url = ""
        self.id = ""
        self.uniqueName = ""
        self.imageUrl = ""
        self.descriptor = ""
    }
    
    // new constructor for widget placeholder and snapshot
    init(displayName: String, uniqueName: String) {
        self.displayName = ""
        self.url = ""
        self.id = ""
        self.uniqueName = uniqueName
        self.imageUrl = ""
        self.descriptor = ""
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.displayName = try values.decode(String.self, forKey: .displayName)
        } catch { self.displayName = "" }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = "" }
        
        do { self.id = try values.decode(String.self, forKey: .id)
        } catch { self.id = "" }
        
        do { self.uniqueName = try values.decode(String.self, forKey: .uniqueName)
        } catch { self.uniqueName = "" }
        
        do { self.imageUrl = try values.decode(String.self, forKey: .imageUrl)
        } catch { self.imageUrl = "" }
        
        do { self.descriptor = try values.decode(String.self, forKey: .descriptor)
        } catch { self.descriptor = "" }
    }
    
    let displayName: String
    let url: String
    let id: String
    let uniqueName: String
    let imageUrl: String
    let descriptor: String
}

class Relations: Codable, Identifiable, Hashable {
    
    init() {
        self.id = 0
        self.sRel = ""
        self.rel = relation.none
        self.url = ""
        self.attributes = Attributes()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.sRel = try values.decode(String.self, forKey: .sRel)
            
            switch sRel {
            case relation.root.rawValue:
                self.rel = relation.root
                
            case relation.related.rawValue:
                self.rel = relation.related
                
            case relation.child.rawValue:
                self.rel = relation.child
                
            case relation.parent.rawValue:
                self.rel = relation.parent
                
            case relation.predecessor.rawValue:
                self.rel = relation.predecessor
                
            case relation.pullRequest.rawValue:
                self.rel = relation.pullRequest
                
            case relation.file.rawValue:
                self.rel = relation.file
                
            default:
                self.rel = relation.none
            }
            
        } catch {
            self.sRel = ""
            self.rel = relation.none
        }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = "" }
        
        do { self.attributes = try values.decode(Attributes.self, forKey: .attributes)
        } catch { self.attributes = Attributes() }
        
        // using values retrieved above populate the id and the relation type enum
        switch self.rel {
        case relation.file, relation.pullRequest:
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
    
    enum CodingKeys: String, CodingKey {
        case sRel = "rel"
        case url = "url"
        case attributes = "attributes"
    }
    
    var id: Int
    private let sRel: String
    let rel: relation
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

class ADOLink: Codable {
    
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
        lSelf = ADOLink()
        html = ADOLink()
        parent = ADOLink()
        wiql = ADOLink()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.lSelf = try values.decode(ADOLink.self, forKey: .lSelf)
        } catch { self.lSelf = ADOLink() }
        
        do { self.html = try values.decode(ADOLink.self, forKey: .html)
        } catch { self.html = ADOLink() }
        
        do { self.parent = try values.decode(ADOLink.self, forKey: .parent)
        } catch { self.parent = ADOLink() }
        
        do { self.wiql = try values.decode(ADOLink.self, forKey: .wiql)
        } catch { self.wiql = ADOLink() }
    }
    
    enum CodingKeys: String, CodingKey {
        case lSelf = "self"
        case html = "html"
        case parent = "parent"
        case wiql = "wiql"
    }
    
    let lSelf: ADOLink
    let html: ADOLink
    let parent: ADOLink
    let wiql: ADOLink
}
