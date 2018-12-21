//
//  EventsDelegate.swift
//  Fusion
//
//  Created by Charles Imperato on 12/19/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import Foundation
import wvslib

protocol EventsDelegate: Waitable {
    
    // - Notify the view that the events loaded successfully
    func eventsLoaded(_ events: [ViewEvent])
    
    // - Notify the view that the events failed to load
    func eventsLoadFailed(_ message: String)
    
    // - Handle the map request
    func openMaps(_ appleMap: URL?, _ googleMap: URL?)
    
}
