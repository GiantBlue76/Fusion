//
//  EventActionsDelegate.swift
//  Fusion
//
//  Created by Charles Imperato on 1/19/19.
//  Copyright © 2019 Wind Valley Software. All rights reserved.
//

import Foundation
import wvslib

protocol EventActionsDelegate: Waitable {
    
    // - Notifies the view that the event was added to the user's calendar
    func addedToCalendar()
    
    // - Notifies the view that the share menu should be shown
    func showShare()
    
    // - Notifies the view that the navigation menu should be shown
    func showNavigation()
 
    // - Shows an error on the map with an optional message
    func showMapError(_ message: String?)
    
    // - Notifies the view that the map coordinates have been loaded
    func mapLoaded(_ location: (latitude: Double, longitude: Double), _ title: String?)
}
