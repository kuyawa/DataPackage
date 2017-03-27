//
//  JsonParser.swift
//  DataPackage
//
//  Created by Mac Mini on 3/25/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

//  Convenienca class for JSONSerialization
//
//  let dixy = JSON.load("data/sample.json")
//  let json = JSON.serialize(dixy)
//  if JSON.save(dixy, "data/sample.json") { print("Saved") }
//
public class JSON {
    
    public static func load(_ path: String) -> Datamap {
        var dixy = Datamap()
        
        do {
            let json = try String(contentsOfFile: path, encoding: .utf8)
            let data = json.data(using: .utf8)!
            //let data = try Data(contentsOf: URL(string: path)!)
            dixy = try JSONSerialization.jsonObject(with: data, options: []) as! Datamap
        } catch {
            print("JSON.error: ", error)
        }
        
        return dixy
    }
    
    public static func load(url: URL) -> Datamap {
        return JSON.load(url.path)
    }
    
    @discardableResult
    public static func save(_ dixy: Datamap, path: String) -> Bool {
        var ok = true
        let json = JSON.serialize(dixy)
        if json.isEmpty { print("JSON.empty"); return false }

        do {
            try json.write(toFile: path, atomically: false, encoding: .utf8)
        } catch {
            print("JSON.error: ", error)
            ok = false
        }
        
        return ok
    }

    public static func serialize(_ dixy: Datamap) -> String {
        var text = ""
    
        do {
            let json = try JSONSerialization.data(withJSONObject: dixy, options: .prettyPrinted)
            text = String(data: json, encoding: .utf8)!
        } catch {
            print("JSON.error: ", error)
        }
    
        return text
    }
}
