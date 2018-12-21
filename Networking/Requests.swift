//
//  Requests.swift
//  Fusion
//
//  Created by Charles Imperato on 12/20/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import Foundation
import wvslib

// - Makes a request to get events and venues
struct EventsRequest: Request {
    typealias T = Data

    var id: String {
        return "eventsRequest_\(UUID.init().uuidString)"
    }
    
    var relativePath: String {
        return "/events.json"
    }
    
    var method: httpMethod {
        return .get
    }
    
    func onSuccess(_ data: Data) -> Data {
        return data
    }
}

