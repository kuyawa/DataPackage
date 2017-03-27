//
//  Resource.swift
//  DataPackage
//
//  Created by Mac Mini on 3/22/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

public class Resource {
    public var path        = "" // {DataPackage}/data/
    public var profile     = "default"
    public var name        = ""            // Required
    public var title       = ""
    public var descript    = ""
    public var format      = ""
    public var mediatype   = ""
    public var encoding    = "utf-8"
    public var bytes       = 0
    public var hash        = ""
    public var data        = [String]()    // Required
    public var schema      = Schema()
    public var homepage    = WebPage()
    public var licenses    = [License]()
    public var sources     = [Source]()

    public func load(map: Datamap) {
        profile      = map["profile"]     as? String ?? "default"
        name         = map["name"]        as? String ?? ""
        title        = map["title"]       as? String ?? ""
        descript     = map["description"] as? String ?? ""
        format       = map["format"]      as? String ?? ""
        mediatype    = map["mediatype"]   as? String ?? ""
        encoding     = map["encoding"]    as? String ?? "utf-8"
        hash         = map["hash"]        as? String ?? ""
        bytes        = map["bytes"]       as? Int    ?? 0
        
        // Complex elements
        
        // Data
        if let list = map["data"] as? [String] {
            data = list
        }

        // Homepage
        if let page = map["homepage"] as? Datamap {
            homepage.name = page["name"]  as? String ?? ""
            homepage.uri  = page["uri"]   as? String ?? ""
        }
        
        // Licenses
        if let list2 = map["licenses"] as? [Datamap] {
            for item in list2 {
                let obj   = License()
                obj.name  = item["name"]  as? String ?? ""
                obj.title = item["title"] as? String ?? ""
                obj.uri   = item["uri"]   as? String ?? ""
                licenses.append(obj)
            }
        }
        
        // Sources
        if let list3 = map["sources"] as? [Datamap] {
            for item in list3 {
                let obj   = Source()
                obj.name  = item["name"]  as? String ?? ""
                obj.uri   = item["uri"]   as? String ?? ""
                obj.email = item["email"] as? String ?? ""
                sources.append(obj)
            }
        }

        // Schema
        if let dixy = map["schema"] as? Datamap {
            schema.load(map: dixy)
        }

    }
    
    public func save() {
        // TODO: save to file
    }
    
    public func toDixy() -> Datamap {
        var dixy = Datamap()
        dixy["profile"]     = profile
        dixy["name"]        = name
        dixy["title"]       = title
        dixy["description"] = descript
        dixy["format"]      = format
        dixy["mediatype"]   = mediatype
        dixy["encoding"]    = encoding
        dixy["bytes"]       = bytes
        dixy["hash"]        = hash
        dixy["data"]        = data
        dixy["schema"]      = schema.toDixy()
        dixy["homepage"]    = homepage.toDixy()
        dixy["licenses"]    = licenses.map{ $0.toDixy() }
        dixy["sources"]     = sources.map{ $0.toDixy() }

        return dixy
    }
    
    public func data(name: String) -> Dataset {
        for item in self.data {
            if item == name {
                let path = self.path + "/" + name
                let data = CSV.load(path)
                return data
            }
        }
        
        return Dataset() // nil?
    }
    
    /*
    public func dataMap(name: String) -> [Datamap] {
        for item in self.data {
            if item == name {
                let path = self.path + "/" + name
                let data = CSV.loadMap(file: path)
                return data
            }
        }
        
        return Dataset() // nil?
    }
    */
}
