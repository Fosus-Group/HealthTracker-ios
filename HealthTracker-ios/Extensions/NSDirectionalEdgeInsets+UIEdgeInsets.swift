//
//  NSDirectionalEdgeInsets+UIEdgeInsets.swift
//
//  Created by sergey on 13.09.2023.
//

import UIKit

extension NSDirectionalEdgeInsets {
    static func make(_ collection: [CGFloat]) -> Self {
        guard !collection.isEmpty else { return .zero }
        var values: [CGFloat] = [0,0,0,0]
        for i in collection.indices {
            values[i] = collection[i]
        }
        return .init(top: values[0], leading: values[1], bottom: values[2], trailing: values[3])
    }
    static func make(_ sequence: CGFloat...) -> Self {
        guard !sequence.isEmpty else { return .zero }
        var values: [CGFloat] = [0,0,0,0]
        for i in sequence.indices {
            values[i] = sequence[i]
        }
        return .init(top: values[0], leading: values[1], bottom: values[2], trailing: values[3])
    }
    static func tuple( _ tuple: (
        top: CGFloat,
        leading: CGFloat,
        bottom: CGFloat,
        trailing: CGFloat)) -> Self {
        return .init(
            top: tuple.top,
            leading: tuple.leading,
            bottom: tuple.bottom,
            trailing: tuple.trailing
        )
    }
    func uiEdgeInsets() -> UIEdgeInsets {
        return .init(
            top: top,
            left: leading,
            bottom: bottom,
            right: trailing
        )
    }
}

extension UIEdgeInsets {
    static func make(_ sequence: CGFloat...) -> Self {
        guard !sequence.isEmpty else { return .zero }
        var values: [CGFloat] = [0,0,0,0]
        for i in sequence.indices {
            values[i] = sequence[i]
        }
        return .init(top: values[0], left: values[1], bottom: values[2], right: values[3])
    }
    static func tuple( _ tuple: (
        top: CGFloat,
        leading: CGFloat,
        bottom: CGFloat,
        trailing: CGFloat)) -> Self {
        return .init(
            top: tuple.top,
            left: tuple.leading,
            bottom: tuple.bottom,
            right: tuple.trailing
        )
    }
    func nsDirectionalEdgeInsets() -> NSDirectionalEdgeInsets {
        return .init(
            top: top,
            leading: left,
            bottom: bottom,
            trailing: right
        )
    }
}
