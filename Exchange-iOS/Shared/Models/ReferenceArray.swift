//
//  ReferenceArray.swift
//  Exchange-iOS
//
//  Created by Kristopher Jackson on 5/22/22.
//

import Foundation

/// Custom array represented as a reference type
/// Contains a closures that allows for observing changes
open class ReferenceArray<T> {
    
    private var array: [T] {
        didSet {
            didUpdate?(oldValue)
        }
        willSet {
            willUpdate?(newValue)
        }
    }
    
    public var objects: [T] { array }
    public var count: Int { array.count }
    
    /// Observe changes to array
    public var didUpdate: ((_ oldArray: [T]) -> Void)?
    public var willUpdate: ((_ newArray: [T]) -> Void)?
    
    init(_ array: [T]) {
        self.array = array
    }
    
    public func add(_ object: T) {
        array.append(object)
    }
    
    public func set(to newArray: [T]) {
        array = newArray
    }
    
    public func insert(_ object: T, at index: Int) {
        array.insert(object, at: index)
    }
    
    public func remove(at index: Int) -> T {
        return array.remove(at: index)
    }
    
}
