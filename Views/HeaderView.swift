//
//  HeaderView.swift
//  Fusion
//
//  Created by Charles Imperato on 12/19/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
    }
    
    init() {
        super.init(frame: .zero)
        self.layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

fileprivate extension HeaderView {
    func layout() {
        self.backgroundColor = UIColor.white
        
        // - Layout the logo image
        let logoImageView = UIImageView.init()
        logoImageView.clipsToBounds = true
        logoImageView.image = UIImage.init(named: "FusionLogo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFill

        self.addSubview(logoImageView)
        logoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        logoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true        
    }
}
