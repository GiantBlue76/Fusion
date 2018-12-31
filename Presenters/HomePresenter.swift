//
//  HomePresenter.swift
//  Fusion
//
//  Created by Charles Imperato on 12/23/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import Foundation
import wvslib

class HomePresenter {
    
    // - View delegate
    weak var delegate: HomeDelegate?
    
    // - Band members
    fileprivate var bandMembers = [Member]()
    
    func loadBand() {
        let ds = BandDataSource.init()
        
        ds.fetchBand({ (members) in
            self.bandMembers = members
            self.delegate?.bandLoaded(self.mapMembers())
        }) { (error) in
            log.error(error)
        }
    }
    
    func menuItemSelected(_ index: Int) {
        switch index {
            case 0:
                self.delegate?.eventsSelected(EventsPresenter.init())
            
            case 1:
                self.delegate?.songsSelected(SongsPresenter.init())
            
            case 2:
                self.delegate?.showContact()
            
            default:
                break
        }
    }
    
    func memberSelected(_ index: Int) {
        if index >= 0 && index < self.bandMembers.count {
            self.delegate?.memberSelected(self.mapMembers()[index])
        }
    }
}

// MARK: - Private

fileprivate extension HomePresenter {
    func mapMembers() -> [MemberInfo] {
        return self.bandMembers.map({ (member) -> MemberInfo in
            var thumbUrl = member.thumb
            if let url = URL.init(string: member.thumb) {
                thumbUrl = url.relativePath
            }
            
            return MemberInfo(thumbUrl, member.name, member.instrument, member.bio)
        })
    }
}
