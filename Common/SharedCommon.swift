//
//  SharedCommon.swift
//  Fusion
//
//  Created by Charles Imperato on 12/19/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
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

extension UIImage {
    func resizedImage(newSize: CGSize) -> UIImage? {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);

        self.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage? {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize.init(width: size.width / resizeFactor, height: size.height / resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
}
