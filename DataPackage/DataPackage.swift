//
//  DataPackage.swift
//  DataPackage
//
//  Created by Mac Mini on 3/21/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

public typealias Dataset = [[Any]]          // Table: 2d array
public typealias Datamap = [String: Any]    // Table: mapped fields

public class DataPackage {
    public var descriptor = Descriptor()
    public var basePath   : String = ""
    
    // Convenience properties
    
    public var info: Descriptor {
        get { return descriptor }
    }
    
    public var name: String {
        get { return descriptor.name }
    }
    
    public var resources: [Resource] {
        get { return descriptor.resources }
    }

    // Methods
    
    public init() {}
    
    public init(path: String) {
        load(path: path)
    }
    
    public func load(path: String) {
        descriptor.load(path: path)
        basePath = URL(string: path)!.deletingLastPathComponent().absoluteString // Remove file name
    }
    
    public func getResource(_ name: String) -> Resource? {
        for item in descriptor.resources {
            if item.name == name {
                return item
            }
        }
        return nil
    }
    
    func validate() -> Bool {
        let ok = false
        // TODO: ok = self.schema?.validate(data: self.info.toDictionary()) ?? false
        return ok
    }
    
    func toDixy() -> Datamap {
        let dixy = descriptor.toDixy()
        return dixy
    }
    
    public func toJson() -> String {
        let json = descriptor.toJson()
        return json
    }
    
    public func isSafe() -> Bool {
        // TODO:
        return true
    }
    
    public func save(path: String) {
        let json = descriptor.toJson()
        do {
            try json.write(toFile: path, atomically: false, encoding: .utf8)
        } catch {
            print("Save.error: ", error)
        }
    }
    
    public func export(path: String, zip: Bool = false) {
        // TODO: Export all data resources
    }
    
    public func unzip() {
        // TODO:
    }
    
    public func validateZip() {
        // TODO:
    }
    
}

