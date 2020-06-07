//
//  UIFont+Extensions.swift
//  Fusion
//
//  Created by Charles Imperato on 3/7/19.
//  Copyright © 2019 Wind Valley Software. All rights reserved.
//

import Foundation
import UIKit

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
