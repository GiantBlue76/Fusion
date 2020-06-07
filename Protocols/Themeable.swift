//
//  Themeable.swift
//  Fusion
//
//  Created by Charles Imperato on 3/7/19.
//  Copyright © 2019 Wind Valley Software. All rights reserved.
//

import Foundation
import UIKit

protocol Themeable {
    // - The theme color for the application
    var themeColor: UIColor { get }
    
    // - The dark text color for the application
    var darkTextColor: UIColor { get }
    
    // - The light text color for the application
    var lightTextColor: UIColor { get }
    
    // - The body field text color for the application
    var bodyTextColor: UIColor { get }
}

extension Themeable {
    var themeColor: UIColor {
        return UIColor.colorWithHexValue(hex: "289bf3", alpha: 1.0)
    }
    
    var darkTextColor: UIColor {
        return UIColor.colorWithHexValue(hex: "000000", alpha: 0.8)
    }
    
    var lightTextColor: UIColor {
        return UIColor.colorWithHexValue(hex: "FFFFFF", alpha: 0.9)
    }
    
    var bodyTextColor: UIColor {
        return UIColor.colorWithHexValue(hex: "747678", alpha: 0.95)
    }
}
