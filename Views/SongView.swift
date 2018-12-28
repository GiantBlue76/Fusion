//
//  SongView.swift
//  Fusion
//
//  Created by Charles Imperato on 12/27/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import UIKit
import wvslib

// - Header view for song table
class SongHeaderView: UITableViewHeaderFooterView {
    
    lazy var headerLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.headerLabel
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var expandImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = CommonImages.expand.image?.maskedImage(with: UIColor.white)
        return imageView
    }()
    
    var tapHandler: (() -> ())?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.layout()
        
        // - Add the tap gesture
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(_:)))
        tap.numberOfTapsRequired = 1
        
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - actions
    @objc fileprivate func handleTap(_ tap: UITapGestureRecognizer) {
        self.tapHandler?()
    }
}

// MARK: - SongHeaderView Private

fileprivate extension SongHeaderView {
    func layout() {
        self.addSubview(self.headerLabel)
        self.headerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0).isActive = true
        self.headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12.0).isActive = true
        
        self.addSubview(self.expandImageView)
        self.expandImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12.0).isActive = true
        self.expandImageView.topAnchor.constraint(equalTo: self.headerLabel.topAnchor).isActive = true
        self.expandImageView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -12.0).isActive = true
        self.expandImageView.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        self.expandImageView.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
        
        // - Lower priority for leading anchor
        let leading = self.expandImageView.leadingAnchor.constraint(equalTo: self.headerLabel.trailingAnchor, constant: -12.0)
        leading.priority = .defaultLow
        leading.isActive = true
    }
}

// - Displays song info in a view
class SongView: UIView {

    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.font = UIFont.headerLabel
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var artistLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.font = UIFont.bodyLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        self.layout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

fileprivate extension SongView {
    // - Layout the views subviews using autolayout
    func layout() {
        // - Layout the title and sub title
        self.addSubview(self.titleLabel)
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12.0).isActive = true
        self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
        
        self.addSubview(self.artistLabel)
        self.artistLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4.0).isActive = true
        self.artistLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor).isActive = true
        self.artistLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor).isActive = true
        self.artistLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0).isActive = true
    }
}
