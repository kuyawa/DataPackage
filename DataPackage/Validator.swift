//
//  Validator.swift
//  DataPackage
//
//  Created by Mac Mini on 3/22/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

public class Validator {

    var schema    = Datamap()
    var registry  = Registry()
    var validator = Validator()
    
    var errors: [String]?
    
    
    func load(schema: Datamap) {
        self.schema = schema
    }
    
    func load(path: String) {
        self.registry  = loadRegistry()
        self.schema    = loadSchema(path: path, registry: registry)
        self.validator = loadValidator(schema: schema, registry: registry)
        //checkSchema()
    }
    
    func checkSchema() {
        //
    }
    
    func loadRegistry() -> Registry {
        let registry = Registry()
        // Stuff
        return registry
    }
    
    func loadSchema(path: String, registry: Registry) -> Datamap {
        // string? get from registry
        // path? get from file
        // dixy? assign to schema
        let schema = Datamap() // load from path
        //
        return schema
    }
    
    func loadValidator(schema: Datamap, registry: Registry) -> Validator {
        let validator = Validator()
        return validator
    }
    

    func validate(data: Datamap) -> Bool {
        let ok = true
        
        return ok
    }

    func validate(schema: Schema) -> Bool {
        let ok = true
        
        return ok
    }
    
}
