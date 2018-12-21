//
//  DataModel.swift
//  Fusion
//
//  Created by Charles Imperato on 12/19/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Song Genre
struct Genre: Codable {
    let id: String
    let title: String
}

// - MARK: - Song
struct Song: Codable {
    enum CodingKeys: String, CodingKey {
        case genreId = "genre_id"
        case title
        case artist
    }
    
    let title: String
    let artist: String
    let genreId: String
}

// - MARK: - Band Member
struct Member: Codable {
    let name: String
    let imageUrl: String
    let thumbnailUrl: String
    let instrument: String
    let bio: String
}

// - MARK: - Venue
struct Venue: Codable {
    let id: String
    let name: String
    let poster: String
    let address: String
    let city: String
    let state: String
//    let lat: Double
//    let lon: Double
}

// MARK: - Event
struct Event: Codable {
    enum CodingKeys: String, CodingKey {
        case venueId = "venue_id"
        case start
        case end
        case summary
    }
    
    let start: String
    let end: String
    let venueId: String
    let summary: String
}
