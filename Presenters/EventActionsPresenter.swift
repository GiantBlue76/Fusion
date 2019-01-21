//
//  EventActionsPresenter.swift
//  Fusion
//
//  Created by Charles Imperato on 1/19/19.
//  Copyright © 2019 Wind Valley Software. All rights reserved.
//

import Foundation
import MapKit
import wvslib

typealias EventInfo = (event: Event, venue: Venue)

class EventActionsPresenter {
    
    // - View
    weak var delegate: EventActionsDelegate?
    
    // - The associated event data
    fileprivate let eventInfo: (event: Event, venue: Venue)
    
    // - Initializer
    init(withInfo info: EventInfo) {
        self.eventInfo = info
    }
    
    func loadMap() {
        let address = self.eventInfo.venue.address
        let city = self.eventInfo.venue.city
        let state = self.eventInfo.venue.state
        
        let geocoder = CLGeocoder.init()
        geocoder.geocodeAddressString("\(address), \(city), \(state)") { (placemarks, error) in
            if let error = error {
                // TODO: Show error in map
                log.error("The data for the map could not be loaded. \(error).")
                return
            }
            
            guard let location = placemarks?.first?.location else {
                log.warning("The venue location could not be found.")
                // TODO: Show error
                return
            }
            
            self.delegate?.mapLoaded((Double(location.coordinate.latitude), Double(location.coordinate.longitude)), self.eventInfo.venue.name)
        }
    }
    
    func navigate() {
        // TODO: Show navigation menu
    }
    
    func share() {
        // TODO: show share menu
    }
}
