//
//  Diagram.swift
//  Formatho
//
//  Created by Luiz Carlos Maia Junior on 13/10/22.
//

import SwiftUI

struct CollectDict<Key: Hashable, Value>: PreferenceKey {
    static var defaultValue: [Key:Value] { [:] }
    static func reduce(value: inout [Key:Value], nextValue: () -> [Key:Value]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct RoundedCircleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 50, height: 50)
            .background(Circle().stroke())
            .background(Circle().fill(Color.white))
            .padding(10)
    }
}

struct Line: Shape {
    var from: CGPoint
    var to: CGPoint
    /*var animatableData: AnimatablePair<CGPoint, CGPoint> {
        get { AnimatablePair(from, to) }
        set {
            from = newValue.first
            to = newValue.second
        }
    }*/
    
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: self.from)
            p.addLine(to: self.to)
        }
    }
}

struct DiagramSimple<A: Identifiable, V: View>: View {
    let tree: Tree<A>
    let node: (A) -> V
    
    typealias Key = CollectDict<A.ID, Anchor<CGPoint>>
    
    var body: some View {
        return VStack(alignment: .center) {
            
            node(tree.value)
                .anchorPreference(key: Key.self, value: .center, transform: {
                    [self.tree.value.id: $0]
                })
            
            HStack(alignment: .bottom, spacing: 10) {
                ForEach(tree.children, id: \.value.id, content: { child in
                    DiagramSimple(tree: child, node: self.node)
                })
            }
        }
        .backgroundPreferenceValue(Key.self, { (centers: [A.ID: Anchor<CGPoint>]) in
            GeometryReader { proxy in
                ForEach(self.tree.children, id: \.value.id, content: { child in
                    Line(
                        from: proxy[centers[self.tree.value.id]!],
                        to: proxy[centers[child.value.id]!]
                    ).stroke()
                })
            }
        })
    }
}


let binaryTree = Tree<Int>(50, children: [
    Tree(17, children: [
        Tree(12),
        Tree(23)
    ]),
    Tree(72, children: [
        Tree(54),
        Tree(72)
    ])
])

/*
struct DiagramSimple_Previews: PreviewProvider {
    
    let uniqueTree: Tree<Unique<Int>> = binaryTree.map(Unique.init)

    static var previews: some View {
        DiagramSimple(tree: uniqueTree, node: { value in
            Text("\(value.value)")
        })
    }
}
*/
