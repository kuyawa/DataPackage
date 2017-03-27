//
//  Descriptor.swift
//  DataPackage
//
//  Created by Mac Mini on 3/21/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

public class Descriptor {
    public var map = Datamap()  // Raw dictionary
    
    public var id           = ""
    public var name         = ""    // required
    public var title        = ""
    public var descript     = ""
    public var profile      = "default"
    public var owner        = ""
    public var author       = ""
    public var contributors = [Contributor]()
    public var license      = ""
    public var licenses     = [License]()
    public var version      = ""
    public var uri          = ""
    public var path         = ""
    public var email        = ""
    public var created      = ""
    public var lastUpdated  = ""
    public var image        = ""
    public var homepage     = WebPage()
    public var downloadUrl  = ""
    public var readme       = ""
    public var readmeHtml   = ""
    public var isCore       = false
    public var keywords     = [String]()
    public var sources      = [Source]()
    public var resources    = [Resource]()

    
    public func load(path: String) {
        do {
            //let json = try Data(contentsOf: URL(string: path)!)
            let json = try String(contentsOfFile: path, encoding: .utf8)
            let data = json.data(using: .utf8)!
            let dixy = try JSONSerialization.jsonObject(with: data, options: []) as! Datamap
            self.path = URL(string: path)!.deletingLastPathComponent().absoluteString
            load(map: dixy)
        } catch {
            print("Descriptor.load.error: ", error)
        }
    }
    
    public func load(map: Datamap) {
        self.map = map
        
        id           = map["id"]            as? String ?? ""
        name         = map["name"]          as? String ?? ""
        title        = map["title"]         as? String ?? ""
        descript     = map["description"]   as? String ?? ""
        profile      = map["profile"]       as? String ?? ""
        owner        = map["owner"]         as? String ?? ""
        author       = map["author"]        as? String ?? ""
        license      = map["license"]       as? String ?? ""
        version      = map["version"]       as? String ?? ""
        uri          = map["uri"]           as? String ?? ""
        email        = map["email"]         as? String ?? ""
        created      = map["created"]       as? String ?? ""
        lastUpdated  = map["lastUpdated"]   as? String ?? ""
        image        = map["image"]         as? String ?? ""
        downloadUrl  = map["downloadUrl"]   as? String ?? ""
        readme       = map["readme"]        as? String ?? ""
        readmeHtml   = map["readmeHtml"]    as? String ?? ""
        isCore       = map["isCore"]        as? Bool   ?? false

        
        // Complex elements
        
        // Keywords
        if let words = map["keywords"] as? [String] {
            keywords = words
        }
        
        // Homepage
        if let page = map["homepage"] as? Datamap {
            homepage.name = page["name"]  as? String ?? ""
            homepage.uri  = page["uri"]   as? String ?? ""
        }
        
        // Contributors
        if let list1 = map["contributors"]  as? [Datamap] {
            for item in list1 {
                let obj   = Contributor()
                obj.name  = item["name"]  as? String ?? ""
                obj.email = item["email"] as? String ?? ""
                obj.uri   = item["uri"]   as? String ?? ""
                obj.role  = item["role"]  as? String ?? ""
                contributors.append(obj)
            }
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

        // Resources
        if let list4 = map["resources"] as? [Datamap] {
            for item in list4 {
                let obj = Resource()
                obj.load(map: item)
                obj.path = self.path + "data/"  // Hardcoded?
                resources.append(obj)
            }
        }
        
    }
    
    public func toJson() -> String {
        let dixy = self.toDixy()
        let json = JSON.serialize(dixy)
        return json
    }
    
    public func toDixy() -> Datamap {
        var dixy = Datamap()
        dixy["id"]           = id
        dixy["name"]         = name
        dixy["title"]        = title
        dixy["description"]  = descript
        dixy["profile"]      = profile
        dixy["owner"]        = owner
        dixy["author"]       = author
        dixy["contributors"] = contributors.map{ $0.toDixy() }
        dixy["license"]      = license
        dixy["licenses"]     = licenses.map{ $0.toDixy() }
        dixy["version"]      = version
        dixy["uri"]          = uri
        dixy["email"]        = email
        dixy["created"]      = created
        dixy["lastUpdated"]  = lastUpdated
        dixy["image"]        = image
        dixy["homepage"]     = homepage.toDixy()
        dixy["downloadUrl"]  = downloadUrl
        dixy["readme"]       = readme
        dixy["readmeHtml"]   = readmeHtml
        dixy["isCore"]       = isCore
        dixy["keywords"]     = keywords
        dixy["sources"]      = sources.map{ $0.toDixy() }
        dixy["resources"]    = resources.map{ $0.toDixy() }

        return dixy
    }
}
