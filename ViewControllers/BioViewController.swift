//
//  BioViewController.swift
//  Fusion
//
//  Created by Charles Imperato on 12/26/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import UIKit
import wvslib

class BioViewController: UIViewController {

    // - Subviews
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.0
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var emptyTopView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    fileprivate lazy var contentView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.sharedBlue
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    lazy var textView: UITextView = {
        let view = UITextView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
        view.isEditable = false
        view.font = UIFont.bodyLabel
        view.textColor = UIColor.white
        view.textAlignment = .left
        view.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.headerLabel
        label.textColor = UIColor.white
        return label
    }()
    
    lazy var instrumentLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bodyLabel
        label.textColor = UIColor.white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clear
        
        self.layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.imageView.layer.cornerRadius = self.imageView.bounds.width / 2.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textView.animateScrollViewBound(.vertical)
    }
}

// MARK: - Private

fileprivate extension BioViewController {
    func layout() {
        self.view.addSubview(self.emptyTopView)
        self.emptyTopView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.emptyTopView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.emptyTopView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.emptyTopView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        self.view.addSubview(self.contentView)
        self.contentView.topAnchor.constraint(equalTo: self.emptyTopView.bottomAnchor).isActive = true
        self.contentView.leadingAnchor.constraint(equalTo: self.emptyTopView.leadingAnchor).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.emptyTopView.trailingAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        self.view.addSubview(self.imageView)
        self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.contentView.topAnchor, constant: -30.0).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 160.0).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 160.0).isActive = true
        
        self.contentView.addSubview(self.nameLabel)
        self.nameLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 12.0).isActive = true
        self.nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12.0).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12.0).isActive = true
        
        self.contentView.addSubview(self.instrumentLabel)
        self.instrumentLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 8.0).isActive = true
        self.instrumentLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor).isActive = true
        self.instrumentLabel.trailingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor).isActive = true
        
        self.contentView.addSubview(self.textView)
        self.textView.topAnchor.constraint(equalTo: self.instrumentLabel.bottomAnchor, constant: 12.0).isActive = true
        self.textView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12.0).isActive = true
        self.textView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12.0).isActive = true
        self.textView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12.0).isActive = true
    }
}
