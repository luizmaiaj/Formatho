//
//  ADO.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 18/9/22.
//

import Foundation

class ADOProjectSearch: Codable, Identifiable {
    
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

class RecentActivity: Codable, Identifiable {
    
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

class ADOWitSearch:Codable, Identifiable {
    
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
        id = Int()
        fields = Fields()
        url = String()
        html = String()
        relations = [Relations]()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.id = try values.decode(Int.self, forKey: .id)
        } catch { self.id = 0 }
        
        do { self.fields = try values.decode(Fields.self, forKey: .fields)
        } catch { self.fields = Fields() }
        
        do { self.url = try values.decode(String.self, forKey: .url)
        } catch { self.url = "" }
        
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
        self.rel = String()
        self.url = String()
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
        
    }
  
    // equatable
    static func == (lhs: Relations, rhs: Relations) -> Bool {
        return lhs.id == rhs.id
    }
    
    // hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    let id = UUID()
    let rel: String
    let url: String
    let attributes: Attributes
}

class Attributes: Codable, Identifiable {
    
    init() {
        self.isLocked = false
        self.name = String()
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do { self.isLocked = try values.decode(Bool.self, forKey: .isLocked)
        } catch { self.isLocked = false }
        
        do { self.name = try values.decode(String.self, forKey: .name)
        } catch { self.name = "" }
        
    }
    
    let isLocked: Bool
    let name: String
}

class ADOQuerySearch: Codable, Identifiable, Hashable {
    
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
    static func == (lhs: ADOQuerySearch, rhs: ADOQuerySearch) -> Bool {
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
        self.id = Int()
        self.url = String()
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
