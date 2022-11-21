//
//  Definitions.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 13/10/22.
//

import Foundation

// for debugging
let HTTP_DATA = false
let HTTP_ERROR = true
let DEBUG_INFO = false
let DEBUG_BUTTON = false

// how many levels from the current node to fetch for the links
let RELATIONS_LEVELS = 1

// Azure DevOps limit on the number of wits that can be fetched at once
let ADO_LIST_LIMIT: Int = 200

enum relation: String {
    case root = "root"
    case related = "System.LinkTypes.Related"
    case file = "AttachedFile"
}
