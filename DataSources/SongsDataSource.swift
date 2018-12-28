//
//  SongsDataSource.swift
//  Fusion
//
//  Created by Charles Imperato on 12/26/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import Foundation
import wvslib

class SongDataSource {
    // - Fetches the genres for the songs
    func fetchGenres(_ onSuccess: @escaping (_ genres: [Genre]) -> (), _ onFailure: @escaping (_ error: String) -> ()) {
        let request = SongsRequest()
        
        request.sendRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                    case .error(let error):
                        log.error("Unable to fetch the genre list. \(error)")
                        onFailure(error.localizedDescription)
                    
                    case .success(let data):
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any], let genresJson = json["genres"] {
                                let genres = try JSONDecoder.init().decode([Genre].self, from: try JSONSerialization.data(withJSONObject: genresJson))
                                onSuccess(genres)
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
    
    // - Fetches the song list
    func fetchSongs(_ onSuccess: @escaping (_ songs: [Song]) -> (), _ onFailure: @escaping (_ error: String) -> ()) {
        let request = SongsRequest()
        
        request.sendRequest { (result) in
            DispatchQueue.main.async {
                switch result {
                    case .error(let error):
                        log.error("Unable to fetch the song list. \(error)")
                        onFailure(error.localizedDescription)
                    
                    case .success(let data):
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any], let songsJson = json["songs"] {
                                let songs = try JSONDecoder.init().decode([Song].self, from: try JSONSerialization.data(withJSONObject: songsJson))
                                onSuccess(songs)
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
