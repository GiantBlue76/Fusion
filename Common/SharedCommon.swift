//
//  SharedCommon.swift
//  Fusion
//
//  Created by Charles Imperato on 12/19/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import Foundation
import UIKit
import wvslib

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

extension UIFont {
    
    static var bodyLabel: UIFont {
        get {
            return UIFont.init(name: "HelveticaNeue", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        }
    }
    
    static var headerLabel: UIFont {
        get {
            return UIFont.init(name: "HelveticaNeue-Bold", size: 15.0) ?? UIFont.systemFont(ofSize: 15.0)
        }
    }
    
    static var titleLabel: UIFont {
        get {
            return UIFont.init(name: "HelveticaNeue-Bold", size: 17.0) ?? UIFont.systemFont(ofSize: 17.0)
        }
    }
}

extension UIColor {
    class var sharedBlue: UIColor {
        return UIColor.colorWithHexValue(hex: "289bf3", alpha: 1.0)
    }
}

extension UICollectionView: Waitable {}
