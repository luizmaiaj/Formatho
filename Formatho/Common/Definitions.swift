//
//  Definitions.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 13/10/22.
//

import Foundation

// for debugging
let HTTP_DATA = false
let HTTP_ERROR = false
let DEBUG_INFO = false
let DEBUG_BUTTON = false

let APP_GROUP = "group.io.red8.formatho"
let BASE_URL = "https://dev.azure.com/"

// how many levels from the current node to fetch for the links
let RELATIONS_LEVELS = 1

// Azure DevOps limit on the number of wits that can be fetched at once
let ADO_LIST_LIMIT: Int = 200
let ADO_TREE_LIMIT: Int = 1000

let QUERY_MIN_WIDTH: CGFloat = 250.0

enum relation: String {
    case none = "none"
    case root = "root"
    case related = "System.LinkTypes.Related"
    case child = "System.LinkTypes.Hierarchy-Forward"
    case parent = "System.LinkTypes.Hierarchy-Reverse"
    case predecessor = "System.LinkTypes.Dependency-Reverse"
    case pullRequest = "ArtifactLink"
    case file = "AttachedFile"
}

enum workItemType: String {
    case epic = "Epic"
    case userStory = "User Story"
    case issue = "Issue"
    case feature = "Feature"
    case pbi = "Product Backlog Item"
    case impediment = "Impediment"
    case bug = "Bug"
    case task = "Task"
}

enum Tab: Int {
    case login = 0
    case wit = 1
    case recent = 2
    case query = 3
    case graph = 4
    case tree = 5
    case list = 6
}
