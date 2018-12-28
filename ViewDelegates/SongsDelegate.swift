//
//  SongsDelegate.swift
//  Fusion
//
//  Created by Charles Imperato on 12/26/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import Foundation
import wvslib

// - View type alias for song info from the presenter
typealias SongInfo = (name: String, artist: String, genre: String)

protocol SongsDelegate: Waitable {
    
    // - Notify the view that the songs have been loaded
    func songsLoaded(_ sortedSections: [String])
    
    // - Notify the view that the section has been updated
    func sectionLoaded(_ index: Int, _ songs: [SongInfo])
}
