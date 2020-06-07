//
//  Shared.swift
//  Fusion
//
//  Created by Charles Imperato on 3/7/19.
//  Copyright © 2019 Wind Valley Software. All rights reserved.
//

import Foundation
import wvslib

fileprivate struct Shared {
    // REST cache
    static let restCache = DefaultCache<CodableData>(name: "fusion-rest-cache")
    
    // Images cache
    static let imageCache = DefaultCache<CodableImage>(name: "fusion-image-cache")
    
    // - Logger
    static let log = Log()
}

struct World {
    // - Current logger
    var log = { Shared.log }
    
    // - Rest data cache
    var restCache = { Shared.restCache }
    
    // - Image cache
    var imageCache = { Shared.imageCache }
    
    // - base path for requests
    var base = { return "https://fusionatx.com" }
    
    // - Events retrieval
    var events = { return Events() }
    
    // - Songs retrieval
    var songs = { return Songs() }
    
    // - Members retrieval
    var members = { return Members() }
}

var Current = World()

// - Rest

struct Events {
    var getEvents: (_ closure: @escaping ResultClosure<[Event]>) -> () = { closure in
        Request<[Event]>(base: Current.base(), path: "/events.json").send({ (result) in
            DispatchQueue.main.async { closure(result) }
        })
    }
}

struct Songs {
    var getSongs: (_ closure: @escaping ResultClosure<[Song]>) -> () = { closure in
        Request<[Song]>(base: Current.base(), path: "/songs.json").send({ (result) in
            DispatchQueue.main.async { closure(result) }
        })
    }
}

struct Members {
    var getMembers: (_ closure: @escaping ResultClosure<[Member]>) -> () = { closure in
        Request<[Member]>(base: Current.base(), path: "/members.json").send({ (result) in
            DispatchQueue.main.async { closure(result) }
        })
    }
}
