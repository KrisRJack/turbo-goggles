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
    
    public var objects: [T] {
        didSet {
            didUpdate?(oldValue)
        }
        willSet {
            willUpdate?(newValue)
        }
    }
    
    public var count: Int { objects.count }
    
    /// Observe changes to array
    public var didUpdate: ((_ oldArray: [T]) -> Void)?
    public var willUpdate: ((_ newArray: [T]) -> Void)?
    
    init(_ array: [T]) {
        objects = array
    }
    
    public func add(_ object: T) {
        objects.append(object)
    }
    
    public func set(to newArray: [T]) {
        objects = newArray
    }
    
    public func insert(_ object: T, at index: Int) {
        objects.insert(object, at: index)
    }
    
    public func remove(at index: Int) -> T {
        return objects.remove(at: index)
    }
    
}
