//
//  EventView.swift
//  Fusion
//
//  Created by Charles Imperato on 12/19/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import UIKit
import wvslib

// - Type for map button handler
enum MapButtonType {
    case apple
    case google
    case both
    case none
}

// - Type for a shared event
typealias ShareableEvent = (data: Data, mime: String)

class EventView: UIView {

    // - Subviews
    fileprivate lazy var containerView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()

    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.layer.cornerRadius = 5.0
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage.init(named: "concert")
        return imageView
    }()
    
    lazy var venueImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5.0
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var dateBoxView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bodyLabel
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    lazy var summaryLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.headerLabel
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bodyLabel
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.layout()
    }
    
    private override convenience init(frame: CGRect) {
        self.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}

// MARK: - Private

fileprivate extension EventView {
    func layout() {
        // - Layout the contents
        self.addSubview(self.posterImageView)
        self.posterImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12.0).isActive = true
        self.posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0).isActive = true
        self.posterImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
        self.posterImageView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        self.addSubview(self.venueImageView)
        self.venueImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4.0).isActive = true
        self.venueImageView.topAnchor.constraint(equalTo: self.posterImageView.topAnchor, constant: 4.0).isActive = true
        self.venueImageView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        self.venueImageView.widthAnchor.constraint(equalToConstant: 85.0).isActive = true
        
        self.addSubview(self.containerView)
        self.containerView.topAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: -8.0).isActive = true
        self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.containerView.addSubview(self.dateBoxView)
        self.dateBoxView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
        self.dateBoxView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.dateBoxView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        self.dateBoxView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
        
        self.dateBoxView.addSubview(self.dateLabel)
        self.dateLabel.topAnchor.constraint(equalTo: self.dateBoxView.topAnchor, constant: 8.0).isActive = true
        self.dateLabel.leadingAnchor.constraint(equalTo: self.dateBoxView.leadingAnchor, constant: 8.0).isActive = true
        self.dateLabel.trailingAnchor.constraint(equalTo: self.dateBoxView.trailingAnchor, constant: -8.0).isActive = true
        self.dateLabel.bottomAnchor.constraint(equalTo: self.dateBoxView.bottomAnchor, constant: -8.0).isActive = true
        
        self.containerView.addSubview(self.summaryLabel)
        self.summaryLabel.topAnchor.constraint(equalTo: self.dateBoxView.topAnchor, constant: 20.0).isActive = true
        self.summaryLabel.leadingAnchor.constraint(equalTo: self.dateBoxView.trailingAnchor, constant: 8.0).isActive = true
        self.summaryLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -8.0).isActive = true

        self.containerView.addSubview(self.addressLabel)
        self.addressLabel.topAnchor.constraint(equalTo: self.summaryLabel.bottomAnchor, constant: 8.0).isActive = true
        self.addressLabel.leadingAnchor.constraint(equalTo: self.summaryLabel.leadingAnchor).isActive = true
        self.addressLabel.trailingAnchor.constraint(equalTo: self.summaryLabel.trailingAnchor).isActive = true
        self.addressLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -8.0).isActive = true
    }
}
