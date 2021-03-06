//
//  UniquePlistDataType.swift
//  PlistMapper
//
//  Created by Grzegorz Maciak on 25/03/2019.
//  Copyright © 2019 kodelit. All rights reserved.
//

import Foundation

protocol UniquePlistDataProtocol: PlistDataProtocol, Equatable {
    static var identifierKey:String { get }
    static var ancestorsKey:String? { get }
    var identifier:String { get }
    var ancestors: [Self]? { get set }

    func ancestorsIds() -> [String]?

    /**
     Generates list including self and all ancestors in order of inheritance.

     Firest element is the oldest ancestor, the last is `self`.
     Every next element overrides previous durign composition.

     - Returns: Flatten tree of inheritance
     */
    func flatMapOfInheritance() -> [Self]
    mutating func loadAncestorsTree(with availableTemplatesById:[String: Self])
}

extension UniquePlistDataProtocol {
    func ancestorsIds() -> [String]? {
        if let ancestorsKey = type(of:self).ancestorsKey,
            let ancestors = self.plist[ancestorsKey] as? [String] {
            return ancestors
        }
        return nil
    }

    func flatMapOfInheritance() -> [Self] {
        let ancestors = self.ancestors ?? []
        var components = ancestors.reduce(into: [Self]()) { (result, child) in
            let derivatives = child
                .flatMapOfInheritance()
                .filter({ !result.contains($0) })
            result.append(contentsOf: derivatives)
        }
        if !components.contains(self) {
            components.append(self)
        }
        return components
    }

    mutating func loadAncestorsTree(with availableTemplatesById:[String: Self]) {
        if let ancestorsIds = self.ancestorsIds() {
            let ancestors = ancestorsIds.reduce(into: [Self]()) { (result, id) in
                if var ancestor = availableTemplatesById[id] {
                    ancestor.loadAncestorsTree(with: availableTemplatesById)
                    result.append(ancestor)
                }
            }
            self.ancestors = ancestors
        }
    }

    // MARK: - Equatable

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension UniquePlistDataProtocol {
    func composedPlist(mergeIdentifiedOptions:Bool = true) -> [String: Any] {
        let plists = self.flatMapOfInheritance().map{ $0.plist }
        let result = self.merge(values: plists, mergeOptions: mergeIdentifiedOptions) as? [String: Any] ?? [:]
        return result
    }

    typealias PlistObject = [String: Any]

    private func merge(values:[Any], mergeOptions:Bool) -> Any {
        guard values.count > 0 else {
            fatalError("Not enough values to perform merge!")
        }
        if let dictionaries = values as? [PlistObject] {
            return dictionaries.reduce(into: [String: Any](), { (result, value) in
                result.merge(value, uniquingKeysWith: { (old, new) -> Any in
                    return self.merge(values: [old, new], mergeOptions: mergeOptions)
                })
            })
        }else if let arrays = values as? [[String]] {
            let strings = arrays
                .reduce(into: [String](), { (result, value) in
                    result.append(contentsOf: value)
                })
                // remove duplicates
                .reduce(into: [String](), { (result, value) in
                    if !result.contains(value) {
                        result.append(value)
                    }
                })
            return strings
        }else if mergeOptions, let arrays = values as? [[PlistObject]] {
            let combinedOptions = arrays.reduce(into: [PlistObject](), { (result, value) in
                result.append(contentsOf: value)
            })
            let optionsById = combinedOptions.reduce(into: [String: [PlistObject]]()) { (result, object) in
                let id = (object[Self.identifierKey] as? String) ?? ""
                var objects = result[id] ?? []
                objects.append(object)
                result[id] = objects
            }
            let keys = Array(optionsById.keys).sorted()
            let mergedOptions = keys.map { (key) -> Any in
                let sameIdOptions = optionsById[key] ?? []
                return self.merge(values: sameIdOptions, mergeOptions: false)
            }
            return mergedOptions
        }
        else if let arrays = values as? [[Any]] {
            return arrays.reduce(into: [Any](), { (result, value) in
                result.append(contentsOf: value)
            })
        }else{
            return values.last!
        }
    }
}
