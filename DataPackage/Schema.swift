//
//  Schema.swift
//  DataPackage
//
//  Created by Mac Mini on 3/22/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

public class Schema {
    
    public var fields        = [Field]()
    public var primaryKey    : [String]?
    public var foreignKeys   : [ForeignKey]?
    public var missingValues : [String]?
    
    public func load(path: String) {
        do {
            let data = try Data(contentsOf: URL(string: path)!)
            let dixy = try JSONSerialization.jsonObject(with: data, options: []) as! Datamap
            load(map: dixy)
        } catch {
            print("Schema.load.error: ", error)
        }
    }
    
    public func load(map: Datamap) {
        if let list = map["fields"] as? [Datamap] {
            for item in list {
                let obj = Field()
                obj.name          = item["name"]        as? String ?? "field"
                obj.title         = item["title"]       as? String
                obj.descript      = item["description"] as? String
                obj.type          = item["type"]        as? String
                obj.format        = item["format"]      as? String
                obj.decimalChar   = item["decimalChar"] as? String
                obj.groupChar     = item["groupChar"]   as? String
                
                // Constraints
                if let constraints = item["constraints"] as? [Datamap] {
                    obj.constraints = [Constraint]()
                    for dixy in constraints {
                        let constraint = Constraint()
                        constraint.load(map: dixy)
                        obj.constraints?.append(constraint)
                    }
                }
                
                fields.append(obj)
                

            }
        }
        
        // Primary key
        primaryKey = map["primaryKey"] as? [String]
        
        // Foreign keys
        if let list = map["foreignKey"] as? [Datamap] {
            for item in list {
                let obj = ForeignKey()
                obj.fields = item["fields"]    as? [String]
                if let ref = item["reference"] as? Datamap {
                    let key = FieldKey()
                    key.resource  = ref["resource"] as?  String
                    key.fields    = ref["fields"]   as? [String]
                    obj.reference = key
                }
            }
        }

        // Missing values
        missingValues = map["missingValues"] as? [String]
    }
    
    public func toDixy() -> Datamap {
        var dixy = Datamap()
        
        dixy["fields"]        = fields.map{ $0.toDixy() }
        dixy["primaryKey"]    = primaryKey
        dixy["foreignKeys"]   = foreignKeys?.map{ $0.toDixy() }
        dixy["missingValues"] = missingValues
        
        return dixy
    }
    
    public func toJson() -> String {
        let dixy = self.toDixy()
        let json = JSON.serialize(dixy)
        return json
    }
    
}


public class Field {
    public var name        = ""
    public var title       : String?
    public var descript    : String?
    public var type        : String?
    public var format      : String?
    public var decimalChar : String?
    public var groupChar   : String?
    public var constraints : [Constraint]?

    public func toDixy() -> Datamap {
        var dixy = Datamap()
        dixy["name"]        = name
        dixy["title"]       = title
        dixy["description"] = descript
        dixy["type"]        = type
        dixy["format"]      = format
        dixy["decimalChar"] = decimalChar
        dixy["groupChar"]   = groupChar
        dixy["constraints"] = constraints?.map{ $0.toDixy() }
        return dixy
    }
}


public class Constraint {
    public var required    : Bool?  // false
    public var unique      : Bool?  // false
    public var minimum     : Int?
    public var maximum     : Int?
    public var minLength   : Int?
    public var maxLength   : Int?
    public var pattern     : String?
    public var rdfType     : String?
    public var options     : [String]?  // enum
    
    public func load(map: Datamap) {
        required  = map["required"]  as? Bool
        unique    = map["unique"]    as? Bool
        minimum   = map["minimum"]   as? Int
        maximum   = map["maximum"]   as? Int
        minLength = map["minLength"] as? Int
        maxLength = map["maxLength"] as? Int
        pattern   = map["pattern"]   as? String
        rdfType   = map["rdfType"]   as? String
        options   = map["options"]   as? [String]
    }
    
    public func toDixy() -> Datamap {
        var dixy = Datamap()

        dixy["required"]  = required
        dixy["unique"]    = unique
        dixy["minimum"]   = minimum
        dixy["maximum"]   = maximum
        dixy["minLength"] = minLength
        dixy["maxLength"] = maxLength
        dixy["pattern"]   = pattern
        dixy["rdfType"]   = rdfType
        dixy["options"]   = options

        return dixy
    }

}


public class ForeignKey {
    public var fields    : [String]?
    public var reference : FieldKey?

    public func toDixy() -> Datamap {
        var dixy = Datamap()
        dixy["fields"]    = fields
        dixy["reference"] = reference?.toDixy()
        return dixy
    }
}


public class FieldKey {
    public var resource : String?
    public var fields   : [String]?

    public func toDixy() -> Datamap {
        var dixy = Datamap()
        dixy["resource"] = resource
        dixy["fields"]   = fields
        return dixy
    }
}



// End
