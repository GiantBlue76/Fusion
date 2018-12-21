//
//  EventsDataSource.swift
//  Fusion
//
//  Created by Charles Imperato on 12/20/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import Foundation
import wvslib

struct EventsDataSource {
    
    // - Fetch all of the events
    func fetchEvents(_ onSuccess: @escaping (_ events: [Event]) -> (), _ onFailure: @escaping (_ error: String) -> ()) {
        let request = EventsRequest.init()
        request.sendRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                    case .error(let error):
                        onFailure(error.localizedDescription)
                    
                    case .success(let data):
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any], let eventsJson = json["events"] {
                                let events = try JSONDecoder.init().decode([Event].self, from: try JSONSerialization.data(withJSONObject: eventsJson))
                                onSuccess(events)
                            }
                            else {
                                onFailure(JSONError.notFound.localizedDescription)
                            }
                        }
                        catch {
                            onFailure(error.localizedDescription)
                        }
                }
            }
        }
    }
    
    // - Fetch all of the venues
    func fetchVenues(_ onSuccess: @escaping (_ venues: [Venue]) -> (), _ onFailure: @escaping (_ error: String) -> ()) {
        let request = EventsRequest.init()
        
        request.sendRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                    case .error(let error):
                        onFailure(error.localizedDescription)
                        
                    case .success(let data):
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any], let venuesJson = json["venues"] {
                                let venues = try JSONDecoder.init().decode([Venue].self, from: try JSONSerialization.data(withJSONObject: venuesJson))
                                onSuccess(venues)
                            }
                            else {
                                onFailure(JSONError.notFound.localizedDescription)
                            }
                        }
                        catch {
                            onFailure(error.localizedDescription)
                        }
                }
            }
        }
    }
    
}
