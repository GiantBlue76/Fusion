//
//  SongsPresenter.swift
//  Fusion
//
//  Created by Charles Imperato on 12/26/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import Foundation
import wvslib

class SongsPresenter {
    
    // - View delegate
    weak var delegate: SongsDelegate?
    
    // - Songs
    fileprivate var songs = [Song]()
    
    // - Genres
    fileprivate var genres = [Genre]()
    
    // - Songs by genre
    fileprivate var songsByGenre = [String: [Song]]()
    
    // - Expanded genres
    fileprivate var expanded = [Genre]()
    
    func loadSongs(_ useSpinner: Bool = true) {
        let ds = SongDataSource()
        
        if useSpinner {
            self.delegate?.showSpinner("Loading song genres...")
        }
        
        ds.fetchGenres({ (genres) in
            self.delegate?.hideSpinner()
            self.genres = genres.sorted(by: { return $0.title < $1.title })
            
            // - Load the songs
            if useSpinner {
                self.delegate?.showSpinner("Loading songs for genres...")
            }
            
            ds.fetchSongs({ (songs) in
                self.delegate?.hideSpinner()
                self.songs = songs
                
                self.genres.forEach({ (genre) in
                    self.songsByGenre[genre.id] = songs.filter({ return genre.id == $0.genreId }).sorted(by: { return $0.title < $1.title })
                })
                
                // - Filter the genres that have no songs
                self.genres = self.genres.filter({ (genre) -> Bool in
                    if let songs = self.songsByGenre[genre.id], songs.count > 0 {
                        return true
                    }
                    
                    return false
                })
                
                self.delegate?.songsLoaded(self.genres.map({ return $0.title }))
            }, { (error) in
                self.delegate?.hideSpinner()
                log.error(error)
            })
        }) { (error) in
            self.delegate?.hideSpinner()
            log.error(error)
        }
    }
    
    func toggleExpand(_ index: Int) {
        guard index < self.genres.count && index >= 0 else { return }
        
        let genre = self.genres[index]

        // - If this section is expanded then we collapse it and remove the songs
        if self.expanded.contains(where: { $0.id == genre.id }) {
            self.expanded.removeAll(where: { return $0.id == genre.id })
            self.delegate?.sectionLoaded(index, [SongInfo]())
            return
        }
        
        // - Expand the section with the set of songs
        let songs = self.songsByGenre[genre.id]?.map({ return SongInfo($0.title, $0.artist, genre.title) }) ?? [SongInfo]()
        self.expanded.append(genre)
        self.delegate?.sectionLoaded(index, songs.sorted(by: { return $0.name < $1.name }))
    }
}
