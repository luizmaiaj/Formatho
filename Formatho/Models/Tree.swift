//
//  Tree.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 13/10/22.
//

import Foundation

class Unique<A>: Identifiable {
    let value: A
    init(_ value: A) { self.value = value }
}

extension Tree {
    func map<B>(_ transform: (A) -> B) -> Tree<B> {
        Tree<B>(transform(value), children: children.map { $0.map(transform) })
    }
}

struct Tree<A> {
    var value: A
    var children: [Tree<A>] = []
    init(_ value: A, children: [Tree<A>] = []) {
        self.value = value
        self.children = children
    }
}
