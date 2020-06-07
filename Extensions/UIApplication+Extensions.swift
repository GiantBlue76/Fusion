//
//  UIApplication+Extensions.swift
//  Fusion
//
//  Created by Charles Imperato on 3/7/19.
//  Copyright © 2019 Wind Valley Software. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    func supportedMaps() -> MapButtonType {
        guard let googleUrl = URL.init(string: "comgooglemaps://"), let appleUrl = URL.init(string: "http://maps.apple.com") else {
            return .none
        }
        
        if self.canOpenURL(googleUrl) && UIApplication.shared.canOpenURL(appleUrl) {
            return .both
        }
        
        if self.canOpenURL(googleUrl) {
            return .google
        }
        
        if self.canOpenURL(appleUrl) {
            return .apple
        }
        
        return .none
    }
}
