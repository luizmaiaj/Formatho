//
//  Node.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 13/10/22.
//

import SwiftUI

import AppKit // for clipboard access

class Node: ObservableObject, Hashable {
    
    @AppStorage("fetched") private var fetched: [String] = [String]()
    
    @Published var nodes: [Node] = [Node]()
    
    @Published var wit: Wit = Wit() // information on this work item type
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    let baseURL: String = "https://dev.azure.com/"
    
    let service = APIService()
    
    let id = UUID()
    
    // equatable
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
    
    // hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    private func getWitNumber(url: String) -> String {
        
        let result = url.trimmingCharacters(in: .decimalDigits)
        
        if result.hasSuffix("/") {
            
            return String(url.dropFirst(result.count))
        }
        else {
            return ""
        }
    }
    
    private func buildHeader(pat: String, email: String) -> [String : String] {
        
        let authorisation = "Basic " + (String(email + ":" + pat).data(using: .utf8)?.base64EncodedString() ?? "")
        
        let header = ["accept": "application/json", "authorization": authorisation]
        
        if HTTP_DATA {
            print(header)
        }
        
        return header
    }
    
    func getInfo(org: String, pat: String, email: String, id: Int, level: Int = 0) {
        
        self.wit = Wit()
        
        if RELATIONS_LEVELS <= level {
            return
        }
        
        let header = buildHeader(pat: pat, email: email)
        
        self.isLoading = true
        errorMessage = nil
        
        self.fetched.append(id.formatted())
        
        let witBaseUrl: String = baseURL + org + "/_apis/wit/workitems/" + "\(id)" + "?$expand=relations"
        
        let url = NSURL(string: witBaseUrl)! as URL
        
        self.service.fetch(Wit.self, url: url, headers: header) { [unowned self] result in
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                case .failure(let error):
                    if HTTP_ERROR {
                        print("Fetcher error: \(error)")
                    }
                    self.errorMessage = error.localizedDescription
                    
                case .success(let info):
                    if HTTP_DATA {
                        print("Fetcher count: \([info].count)")
                    }
                    self.wit = info
                    
                        /*
                    for r in self.wit.relations {
                        let id: String = self.getWitNumber(url: r.url)
                        let idNumber: Int = Int(id) ?? 0
                        
                        if idNumber > 50000 && idNumber < 500000 && !self.fetched.contains(id) {
                            
                            print("\(level) \(witid) -> \(idNumber)")
                            
                            let node: Node = Node()
                            
                            node.getRelations(org: org, pat: pat, email: email, witid: id, level: level + 1)
                            
                            self.nodes.append(node)
                        }
                    }
                         */
                }
            }
        }
    }
    
    func getNode(org: String, pat: String, email: String, id: Int) {
        
        for node in nodes {
            if node.wit.id == id {
                return
            }
        }
        
        let node: Node = Node()
        
        node.getInfo(org: org, pat: pat, email: email, id: id)
        
        self.nodes.append(node)
    }
}
