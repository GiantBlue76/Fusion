//
//  HomeDelegate.swift
//  Fusion
//
//  Created by Charles Imperato on 12/23/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import Foundation
import wvslib

// - View data for the member
typealias MemberInfo = (thumbUrl: String, name: String, instrument: String, bio: String)

protocol HomeDelegate: Waitable {
    
    // - Notify the view the band info has loaded
    func bandLoaded(_ members: [MemberInfo])
    
    // - Segue to the events view
    func eventsSelected(_ presenter: EventsPresenter)
    
    // - Notify the view when a band member is selected
    func memberSelected(_ memberInfo: MemberInfo)
}
