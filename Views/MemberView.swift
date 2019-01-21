//
//  MemberView.swift
//  Fusion
//
//  Created by Charles Imperato on 12/23/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import UIKit

class MemberView: UIView {
    
    // - Band member image view
    lazy var imageView: UIImageView = {
        let view = UIImageView.init(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.layer.borderWidth = 1.0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}

// MARK: - Private

fileprivate extension MemberView {
    // - Layout subviews with constraints
    func layout() {
        self.addSubview(self.imageView)
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}
