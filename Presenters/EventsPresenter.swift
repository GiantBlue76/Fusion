//
//  EventsPresenter.swift
//  Fusion
//
//  Created by Charles Imperato on 12/19/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import Foundation
import EventKit
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
                
                // - Schedule a reminder notification
                if let firstEvent = self.events.first {
                    var start = firstEvent.start
                    if firstEvent.start.hasSuffix(" UTC") {
                        start = String(firstEvent.start.dropLast(4))
                    }
                    
                    let venue = self.venues.filter({ return $0.id == firstEvent.venueId }).first?.name ?? ""
                    self.delegate?.scheduleReminder(start, venue)
                }
                
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
        
        var address = ""
        if let venue = self.venues.filter({ return $0.id == event.venueId }).first {
            address = "\(venue.address), \(venue.city), \(venue.state)"
        }
        
        self.delegate?.shareEvent("\(event.summary) \(month)/\(day)/\(year)\n\(address)", event.summary, data: shareableEvent.data, mimeType: "image/png")
    }
    
    func select(_ index: Int) {
        let event = self.events[index]
        guard let venue = self.venues.filter({ return $0.id == event.venueId }).first else {
            log.warning("The venue ID could not be loaded")
            return
        }
        
        self.delegate?.showActions(EventActionsPresenter.init(withInfo: (event, venue)))
    }
    
    func addToCalendar(_ index: Int) {
        let bandEvent = self.events[index]
        let start = Date.dateFromUTCString(utc: String(bandEvent.start.dropLast(3)))
        let end = Date.dateFromUTCString(utc: String(bandEvent.end.dropLast(3)))
        
        let eventStore = EKEventStore()
        
        // - Check for duplicates
        guard let startDate = start, let endDate = end else {
            log.warning("The start and end date for the event were invalid.")
            return
        }
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        let existingEvents = eventStore.events(matching: predicate)
        if existingEvents.contains(where: { return $0.title == bandEvent.summary }) {
            self.delegate?.showBanner("This event has already been added to your calendar.")
            return
        }

        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                
                event.title = bandEvent.summary
                event.startDate = start
                event.endDate = end
                event.notes = bandEvent.summary
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                // - Add an alarm for one hour prior
                if let alarmDate = start?.addingTimeInterval(-(60 * 60 * 2)) {
                    event.addAlarm(EKAlarm.init(absoluteDate: alarmDate))
                }

                do {
                    try eventStore.save(event, span: .thisEvent)
                    self.delegate?.showBanner("The event was successfully added to your calendar.")
                }
                catch {
                    log.error("The event could not be added to the calendar. \(error).")
                    self.delegate?.showBanner("The event could not be added to your calendar. \(error).")
                }
            }
            else {
                log.warning("The event could not be added to the calendar")
                if granted == false {
                    self.delegate?.showBanner("Events cannot be added to your calendar until you allow access to your calendar.  Go to the settings app and enable calendar access for the Fusion app.")
                }
            }
        })
    }
    
    func refresh() {
        Shared.dataCache.clear {
            DispatchQueue.main.async {
                self.loadEvents()
            }
        }
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
