//
//  Elements.swift
//  DataPackage
//
//  Created by Mac Mini on 3/23/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import Foundation

public class Contributor {
    public var name  = ""    // Required
    public var email : String?
    public var uri   : String?
    public var role  : String?
    
    public var say: String { return name } // for printing

    public func toDixy() -> Datamap {
        var dixy = Datamap()

        dixy["name"]  = name
        dixy["email"] = email
        dixy["uri"]   = uri
        dixy["role"]  = role

        return dixy
    }
}

public class License {
    public var name  = ""    // Required
    public var title : String?
    public var uri   : String?
    
    public var say: String { return name } // for printing

    public func toDixy() -> Datamap {
        var dixy = Datamap()

        dixy["name"]  = name
        dixy["title"] = title
        dixy["uri"]   = uri

        return dixy
    }
}

public class Source {
    public var name  : String?
    public var uri   = ""     // Required
    public var email : String?
    
    public var say: String { return name ?? "Unknown" } // for printing

    public func toDixy() -> Datamap {
        var dixy = Datamap()

        dixy["name"]  = name
        dixy["uri"]   = uri
        dixy["email"] = email

        return dixy
    }
}

public class WebPage {
    public var name  : String?
    public var uri   : String?
    
    public func toDixy() -> Datamap {
        var dixy = Datamap()

        dixy["name"] = name
        dixy["uri"]  = uri

        return dixy
    }
}


// End
