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

    fileprivate lazy var mapButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1.0
        button.setImage(UIImage.init(named: "maps"), for: .normal)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(handleMap), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var shareButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1.0
        button.setImage(CommonImages.share.image?.resizedImage(newSize: CGSize.init(width: 32.0, height: 32.0)), for: .normal)
        button.contentMode = .center
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(share), for: .touchUpInside)
        return button
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
    
    // - Map button handler
    var mapButtonHandler: ((_ type: MapButtonType) -> ())?
    
    // - Share button handler
    var shareButtonHandler: ((_ event: ShareableEvent) -> ())?
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // - Make the map button circular along with the share button
        self.mapButton.layer.cornerRadius = self.mapButton.bounds.width / 2.0
        self.shareButton.layer.cornerRadius = self.shareButton.bounds.width / 2.0
    }
    
    // - Map button handler
    @objc func handleMap() {
        self.mapButtonHandler?(UIApplication.shared.supportedMaps())
    }
    
    // - Share button handler
    @objc func share() {
        self.mapButton.isHidden = true
        self.shareButton.isHidden = true
        if let data = self.snapshot().pngData() {
            self.shareButtonHandler?((data, "image/png"))
        }
        
        self.mapButton.isHidden = false
        self.shareButton.isHidden = false
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
        self.posterImageView.heightAnchor.constraint(equalToConstant: 120.0).isActive = true
        
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
        
        // - Add the map button
        self.addSubview(self.mapButton)
        self.mapButton.centerYAnchor.constraint(equalTo: self.containerView.topAnchor, constant: -8.0).isActive = true
        self.mapButton.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -74.0).isActive = true
        self.mapButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        self.mapButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        // - Add the share button
        self.addSubview(self.shareButton)
        self.shareButton.centerYAnchor.constraint(equalTo: self.mapButton.centerYAnchor, constant: 0).isActive = true
        self.shareButton.leadingAnchor.constraint(equalTo: self.mapButton.trailingAnchor, constant: 10.0).isActive = true
        self.shareButton.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        self.shareButton.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
    }
}
