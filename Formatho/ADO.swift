//
//  ADO.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 18/9/22.
//

import Foundation

/*
 Projects
{
    "count": 1,
    "value": [
        {
            "id": "1563c3d9-a220-44eb-8320-0e057810adc4",
            "name": "SCOPE-Tamwini",
            "description": "Tamwini, Tasjil, Tamawwon and OpenSPP projects managed by Iraq CO with Newlogic",
            "url": "https://dev.azure.com/worldfoodprogramme/_apis/projects/1563c3d9-a220-44eb-8320-0e057810adc4",
            "state": "wellFormed",
            "revision": 3488,
            "visibility": "private",
            "lastUpdateTime": "2022-09-06T08:30:56.08Z"
        }
    ]
}
*/

/*
Wits
{
    "count": 1,
    "value": [
        {
            "id": 297,
            "rev": 1,
            "fields": {
                "System.AreaPath": "Fabrikam-Fiber-Git",
                "System.TeamProject": "Fabrikam-Fiber-Git",
                "System.IterationPath": "Fabrikam-Fiber-Git",
                "System.WorkItemType": "Product Backlog Item",
                "System.State": "New",
                "System.Reason": "New backlog item",
                "System.CreatedDate": "2014-12-29T20:49:20.77Z",
                "System.CreatedBy": {
                    "displayName": "Jamal Hartnett",
                    "url": "https://vssps.dev.azure.com/fabrikam/_apis/Identities/d291b0c4-a05c-4ea6-8df1-4b41d5f39eff",
                    "_links": {
                        "avatar": {
                            "href": "https://dev.azure.com/mseng/_apis/GraphProfile/MemberAvatars/aad.YTkzODFkODYtNTYxYS03ZDdiLWJjM2QtZDUzMjllMjM5OTAz"
                        }
                    },
                    "id": "d291b0c4-a05c-4ea6-8df1-4b41d5f39eff",
                    "uniqueName": "fabrikamfiber4@hotmail.com",
                    "imageUrl": "https://dev.azure.com/fabrikam/_api/_common/identityImage?id=d291b0c4-a05c-4ea6-8df1-4b41d5f39eff",
                    "descriptor": "aad.YTkzODFkODYtNTYxYS03ZDdiLWJjM2QtZDUzMjllMjM5OTAz"
                },
                "System.ChangedDate": "2014-12-29T20:49:20.77Z",
                "System.ChangedBy": {
                    "displayName": "Jamal Hartnett",
                    "url": "https://vssps.dev.azure.com/fabrikam/_apis/Identities/d291b0c4-a05c-4ea6-8df1-4b41d5f39eff",
                    "_links": {
                        "avatar": {
                            "href": "https://dev.azure.com/mseng/_apis/GraphProfile/MemberAvatars/aad.YTkzODFkODYtNTYxYS03ZDdiLWJjM2QtZDUzMjllMjM5OTAz"
                        }
                    },
                    "id": "d291b0c4-a05c-4ea6-8df1-4b41d5f39eff",
                    "uniqueName": "fabrikamfiber4@hotmail.com",
                    "imageUrl": "https://dev.azure.com/fabrikam/_api/_common/identityImage?id=d291b0c4-a05c-4ea6-8df1-4b41d5f39eff",
                    "descriptor": "aad.YTkzODFkODYtNTYxYS03ZDdiLWJjM2QtZDUzMjllMjM5OTAz"
                },
                "System.Title": "Customer can sign in using their Microsoft Account",
                "Microsoft.VSTS.Scheduling.Effort": 8,
                "WEF_6CB513B6E70E43499D9FC94E5BBFB784_Kanban.Column": "New",
                "System.Description": "Our authorization logic needs to allow for users with Microsoft accounts (formerly Live Ids) - http://msdn.microsoft.com/en-us/library/live/hh826547.aspx"
            },
            "url": "https://dev.azure.com/fabrikam/_apis/wit/workItems/297"
        }
    ]
}
*/

class ADOProjectSearch:Codable, Identifiable {
    
    init() {
        self.value = [Project]()
        self.count = 0
    }
    
    let value: [Project]
    let count: Int
}

class Project: Codable, Identifiable {
    
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
    
    let id: String
    let name: String
    let description: String
    let url: String
    let state: String
    let revision: Int
    let visibility: String
    let lastUpdateTime: String
}

class ADOWitSearch:Codable, Identifiable {
    
    init() {
        self.value = [Wit]()
        self.count = Int()
    }
    
    let value: [Wit]
    let count: Int
}


class Wit: Codable, Identifiable {
    
    init() {
        id = Int()
        fields = Fields()
        url = String()
    }
    
    let id: Int
    let fields: Fields
    let url: String
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
        //self.MicrosoftVSTSSchedulingEffort = Int()
        //self.WEF_6CB513B6E70E43499D9FC94E5BBFB784_KanbanColumn = String()
        self.SystemDescription = String()
        self.MicrosoftVSTSCommonPriority = Int()
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
        //case MicrosoftVSTSSchedulingEffort = "Microsoft.VSTS.Scheduling.Effort"
        //case WEF_6CB513B6E70E43499D9FC94E5BBFB784_KanbanColumn = "WEF_6CB513B6E70E43499D9FC94E5BBFB784_Kanban.Column"
        case SystemDescription = "System.Description"
        case MicrosoftVSTSCommonPriority = "Microsoft.VSTS.Common.Priority"
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
    //let MicrosoftVSTSSchedulingEffort: Int
    //let WEF_6CB513B6E70E43499D9FC94E5BBFB784_KanbanColumn: String
    let SystemDescription: String
    let MicrosoftVSTSCommonPriority: Int
}
