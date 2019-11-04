//
//  Range.swift
//  EasyRecipeUI
//
//  Created by Hsiao, Wayne on 2019/10/7.
//  Copyright © 2019 Hsiao, Wayne. All rights reserved.
//

import Foundation

/// [Property wrapper](https://wayne-blog.herokuapp.com/blog/posts/6)
@propertyWrapper
struct Range<T: Comparable> {
    private var value: T
    private var range: ClosedRange<T>
    private(set) var versions = [Date]()

    init(wrappedValue value: T, _ range: ClosedRange<T>) {
        self.value = value
        self.range = range
    }

    var wrappedValue: T {
        set {
            defer {
                versions.append(Date())
            }
            value = min(max(range.lowerBound, newValue), range.upperBound)
        }
        get {
            value
        }
    }
}
