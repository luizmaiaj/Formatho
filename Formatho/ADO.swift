//
//  ADO.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 18/9/22.
//

import Foundation

/*
{
    "count": 9,
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

class ADOProjectSearch:Codable, Identifiable {
    
    init() {
        self.projects = [Project]()
        self.count = 0
    }
    
    let id = UUID()
    let projects: [Project]
    let count: Int
}

class Project: Codable, Identifiable {
    
    init() {
        id = String()
        name = String()
        description = String()
        url = String()
        state = String()
        revistion = 0
        visibility = String()
        lastUpdateTime = String()
    }
    
    let id: String
    let name: String
    let description: String
    let url: String
    let state: String
    let revistion: Int
    let visibility: String
    let lastUpdateTime: String
    
}
