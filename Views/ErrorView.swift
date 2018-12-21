//
//  ErrorView.swift
//  Fusion
//
//  Created by Charles Imperato on 12/20/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import UIKit
import wvslib

// - Generic view to be displayed for errors or important messages to the user
class ErrorView: UIView {

    // - Message label for the error view
    fileprivate lazy var messageLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.titleLabel
        label.textColor = UIColor.lightGray
        return label
    }()
    
    fileprivate lazy var errorImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = CommonImages.errorsignal.image?.maskedImage(with: UIColor.red)
        return imageView
    }()
    
    // - Text for the message
    var text: String? {
        didSet {
            self.messageLabel.text = self.text
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        // - Set the background
        self.backgroundColor = UIColor.white
        
        // - Layout the constraints
        self.layout()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

fileprivate extension ErrorView {
    func layout() {
        self.addSubview(self.messageLabel)
        self.messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20.0).isActive = true
        self.messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        // - Add the image view
        self.addSubview(self.errorImageView)
        self.errorImageView.bottomAnchor.constraint(equalTo: self.messageLabel.topAnchor, constant: -12.0).isActive = true
        self.errorImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
}
