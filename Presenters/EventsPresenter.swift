//
//  EventsPresenter.swift
//  Fusion
//
//  Created by Charles Imperato on 12/19/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import Foundation
import wvslib

class EventsPresenter {
    
    // - Events view
    weak var delegate: EventsDelegate?
    
    // - Events
    fileprivate var events = [Event]()

    // - Venues by id
    fileprivate var venues = [Venue]()
    
    func loadEvents() {
        let ds = EventsDataSource()

        self.delegate?.showSpinner("Loading Events...")
        
        // - Fetch the venues first
        ds.fetchVenues({ (venues) in
            self.venues = venues
            
            // - Fetch events and handle success or error
            ds.fetchEvents({ (events) in
                self.delegate?.hideSpinner()
                
                // - Map the events to view event data
                self.events = events
                let viewEvents = self.events.map({ (event) -> ViewEvent in
                    var start = event.start
                    if event.start.hasSuffix(" UTC") {
                        start = String(event.start.dropLast(4))
                    }
                    
                    let date = Date.dateFromUTCString(utc: start) ?? Date()
                    let day = Date.dayFromUTCString(start)
                    let time = Date.localTimeFromDate(utc: start)
                    let weekday = self.weekday(forDate: date)
                    let month = self.month(forDate: date)
                    let summary = event.summary.replacingOccurrences(of: "&amp;", with: "&")
                    
                    // - Map the venue to the event
                    var venue = ""
                    var address = ""
                    var posterUrl = "concert"
                    
                    let filteredVenues = self.venues.filter { $0.id == event.venueId }
                    if let ven = filteredVenues.first {
                        venue = ven.name
                        address = "\(ven.address)\n\(ven.city), \(ven.state)"
                        posterUrl = URL.init(string: ven.poster)?.relativePath ?? "concert"
                    }
                    
                    return ViewEvent.init(day: String(day), month: month, date: weekday, time: time, venue: venue, address: address, summary: summary, posterUrl: posterUrl)
                })
                
                self.delegate?.eventsLoaded(viewEvents)
            }) { (error) in
                self.delegate?.hideSpinner()
                
                log.error(error)
                self.delegate?.eventsLoadFailed("Oops! Something went wrong attempting to load the events.\n\n \(error)")
            }
        }) { (error) in
            self.delegate?.hideSpinner()
            
            log.error(error)
            self.delegate?.eventsLoadFailed("Oops! Something went wrong attempting to load the events.\n\n \(error)")
        }
    }
    
    func map(_ type: MapButtonType, _ index: Int) {
        guard index >= 0, index < self.events.count, let venue = self.venues.filter({ (venue) -> Bool in
            return venue.id == self.events[index].venueId
        }).first else {
            log.warning("Unable to open maps application because either the index was invalid or the venue could not be found for event.")
            return
        }
        
        let address = "\(venue.address), \(venue.city), \(venue.state)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let applMap = URL.init(string: "http://maps.apple.com/?saddr&daddr=\(address)")
        let googMap = URL.init(string: "comgooglemaps-x-callback://" + "?saddr&daddr=\(address)" + "&x-success=sourceapp://?resume=true&x-source=AirApp")
        
        switch type {
            case .apple:
                self.delegate?.openMaps(applMap, nil)
            
            case .google:
                self.delegate?.openMaps(nil, googMap)
            
            case .both:
                self.delegate?.openMaps(applMap, googMap)
            
            default:
                break
            // TODO: display error of some sort
         }
    }
    
    func share(_ shareableEvent: ShareableEvent, _ index: Int) {
        let event = self.events[index]
        
        let start = String(event.start.dropLast(3))
        let month = Date.monthFromUTCString(start)
        let day = Date.dayFromUTCString(start)
        let year = Date.yearFromUTCString(start)
        
        self.delegate?.shareEvent("\(event.summary) \(month)/\(day)/\(year)", data: shareableEvent.data, mimeType: "image/png")
    }
}

// MARK: - Private

fileprivate extension EventsPresenter {
    func month(forDate date: Date) -> String {
        let month = DateFormatter().monthSymbols[Calendar.current.component(.month, from: date) - 1].uppercased()
        if month.count > 3 {
            return month.getSubstring(from: 0, to: 3) ?? month
        }
        
        return month
    }
    
    func weekday(forDate date: Date) -> String {
        let weekday = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1].uppercased()
        if weekday.count > 3 {
            return weekday.getSubstring(from: 0, to: 3) ?? weekday
        }
        
        return weekday
    }
}
