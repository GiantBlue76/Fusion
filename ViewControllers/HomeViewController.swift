//
//  HomeViewController.swift
//  Fusion
//
//  Created by Charles Imperato on 12/19/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import UIKit
import MessageUI
import wvslib

class HomeViewController: UIViewController, Notifiable {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.sizeClass == .compact ? .portrait : .all
    }
    
    // - Header view for the home
    fileprivate lazy var headerView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // - Image
        let imageView = UIImageView.init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.init(named: "fusion")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5.0
        
        // - Label
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.headerLabel
        label.textColor = UIColor.darkGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.text = "We're that great band you saw last night!"
        
        // - Layout
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.75).isActive = true
        
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 4.0).isActive = true
        label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -4.0).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        return view
    }()
    
    fileprivate lazy var memberCollectionView: UICollectionView = {
        let collection = UICollectionView.init(frame: .zero, collectionViewLayout: TileLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = UIColor.clear
        collection.dataSource = self
        collection.delegate = self
        (collection.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .vertical
        return collection
    }()
    
    // - Bottom button menu
    fileprivate lazy var buttonMenu: ButtonMenu = {
        let color = UIColor.sharedBlue
        let size = CGSize.init(width: 34.0, height: 34.0)
        
        // - Events button
        let eventImage = UIImage.init(named: "event")?.resizedImage(newSize: size)?.maskedImage(with: color) ?? UIImage.init()
        let eventsButton = ButtonMenuItem("Shows", eventImage)
        
        // - Contact button
        let contactImage = UIImage.init(named: "contact")?.resizedImage(newSize: size)?.maskedImage(with: color) ?? UIImage.init()
        let contactButton = ButtonMenuItem("Contact", contactImage)
        
        // - Song list button
        let songImage = UIImage.init(named: "songs")?.resizedImage(newSize: size)?.maskedImage(with: color) ?? UIImage.init()
        let songButton = ButtonMenuItem("Song List", songImage)
        
        // - Media button
        let mediaImage = UIImage.init(named: "camera")?.resizedImage(newSize: size)?.maskedImage(with: color) ?? UIImage.init()
        let mediaButton = ButtonMenuItem("Media Gallery", mediaImage)
        
        let view = ButtonMenu.init(withItems: [eventsButton, songButton, contactButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        view.menuItemTapped = { (index) in
            self.presenter.menuItemSelected(index)
        }
        return view
    }()
    
    fileprivate lazy var slideInTransitionDelegate: UIViewControllerTransitioningDelegate = {
        let delegate = SlideInPresentationManager.init()
        delegate.direction = .bottom
        delegate.percentage = 0.6
        return delegate
    }()
    
    // - Constraints for the bottom menu
    fileprivate var topConstraint: NSLayoutConstraint?
    fileprivate var botConstraint: NSLayoutConstraint?
    
    // - Band member info
    fileprivate var members = [MemberInfo]() {
        didSet {
            self.memberCollectionView.reloadData()
        }
    }
    
    // - Notiable
    var notifyContainer: UIView?
    
    // - Presenter
    let presenter: HomePresenter
    
    // - If loaded flag
    var isLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        // - Collection view
        self.memberCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "memberCell")
        self.memberCollectionView.alpha = 0
        (self.memberCollectionView.collectionViewLayout as? TileLayout)?.delegate = self
        
        // - Layout the views
        self.layout()
        
        // - Load the band info
        self.memberCollectionView.showSpinner("Loading content.  Please wait...")
        self.presenter.loadBand()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // - Invalidate the collection view layout
        self.memberCollectionView.collectionViewLayout.invalidateLayout()
        
        if self.isLoaded { return }
        
        // - Create zoom effect
        self.headerView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.25, animations: {
                self.headerView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
            }, completion: { (finished) in
                if finished {
                    UIView.animate(withDuration: 0.15, animations: {
                        self.memberCollectionView.alpha = 1.0
                    }, completion: { (finished) in
                        if finished {
                            // - Animate in the menu
                            UIView.animate(withDuration: 0.45, animations: {
                                self.topConstraint?.isActive = false
                                self.botConstraint?.isActive = true
                                self.buttonMenu.superview?.layoutIfNeeded()
                            })
                        }
                    })
                }
            })
        }
        
        self.isLoaded = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (_) in
        }) { (_) in
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    init(withPresenter presenter: HomePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        // - Assign the view
        self.presenter.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UICollectionView

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.members.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath)
        
        var content = MemberView.init(frame: .zero)
        if let view = cell.viewWithTag(100) as? MemberView {
            content = view
            content.imageView.image = nil
        }
        else {
            content.translatesAutoresizingMaskIntoConstraints = false
            content.tag = 100
            
            // - Layout contents
            cell.addSubview(content)
            cell.layer.cornerRadius = 5.0
            cell.clipsToBounds = true
            content.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            content.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
            content.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
            content.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
        }
        
        content.imageView.backgroundColor = UIColor.black
        content.imageView.fetchImage(self.members[indexPath.item].thumbUrl, false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.memberSelected(indexPath.item)
    }
}

// - MARK: - TileLayoutDelegate

extension HomeViewController: TileLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForTileAtIndexPath indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
            case 0:
                return collectionView.bounds.height * 0.45
            
            case 1:
                return collectionView.bounds.height * 0.225
            
            case 2:
                return collectionView.bounds.height * 0.225
            
            case 3:
                return collectionView.bounds.height * 0.225
            
            case 4:
                return collectionView.bounds.height * 0.225
            
            case 5:
                return collectionView.bounds.height * 0.45
            
            default:
                return 0
        }
    }
}

// MARK: - HomeDelegate

extension HomeViewController: HomeDelegate {
    func bandLoaded(_ members: [MemberInfo]) {
        self.memberCollectionView.hideSpinner()
        self.members = members
    }
    
    func eventsSelected(_ presenter: EventsPresenter) {
        self.navigationController?.pushViewController(EventsViewController.init(withPresenter: presenter), animated: true)
    }
    
    func songsSelected(_ presenter: SongsPresenter) {
        self.navigationController?.pushViewController(SongsViewController.init(withPresenter: presenter), animated: true)
    }
    
    func memberSelected(_ memberInfo: MemberInfo) {
        let bioView = BioViewController()
        bioView.transitioningDelegate = self.slideInTransitionDelegate
        bioView.modalPresentationStyle = .custom
        
        // - Set the data to the view
        bioView.imageView.fetchImage(memberInfo.thumbUrl)
        bioView.textView.text = memberInfo.bio
        bioView.instrumentLabel.text = memberInfo.instrument
        bioView.nameLabel.text = memberInfo.name
        
        self.present(bioView, animated: true)
    }
    
    func showContact() {
        let sheet = UIAlertController.init(title: "Contact Fusion", message: "", preferredStyle: .actionSheet)
        let call = UIAlertAction.init(title: "Call", style: .default) { (action) in
            if let url = URL.init(string: "tel://512-655-3330"), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        let email = UIAlertAction.init(title: "Email", style: .default) { (action) in
            if MFMailComposeViewController.canSendMail() {
                let controller = MFMailComposeViewController()
                controller.mailComposeDelegate = self
                
                controller.setSubject("Hello Fusion")
                controller.setToRecipients(["fusion@fusionatx.com"])
                controller.setMessageBody("\n\n\nSent from the Fusion app", isHTML: false)
                self.present(controller, animated: true)
            }
            else {
                let alert = UIAlertController.init(title: "Email Account", message: "You must set up an email account on this device to use this feature.", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default))
            }
        }
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel)
        
        sheet.addAction(call)
        sheet.addAction(email)
        sheet.addAction(cancel)
        self.present(sheet, animated: true)
    }
}

// - MARK: MFMailComposeDelegate

extension HomeViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var message: String?
        switch result {
            case .failed:
                message = "This email could not be sent. \(error?.localizedDescription ?? "")"
            
            case .sent:
                fallthrough
            
            default:
                break
        }
        
        self.hideSpinner()
        
        // - Notify the user that the email was sent
        controller.dismiss(animated: true) {
            if let message = message {
                let alert = UIAlertController.init(title: "Contact Fusion", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else  {
                var message = ""
                if result == .sent {
                    message = "Your message was successfully sent to Fusion."
                }
                else if result == .saved {
                    message = "Your message was saved and was not sent to Fusion."
                }
                else if result == .cancelled {
                    message = "Your message was cancelled and was not sent to Fusion."
                }

                self.notify(message: message, 2.5, UIColor.sharedBlue)
            }
        }
    }
}

// MARK: - Private

fileprivate extension HomeViewController {
    // - Apply all constraints to layout the view
    func layout() {
        self.view.addSubview(self.headerView)
        self.headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.headerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 4.0).isActive = true
        self.headerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -4.0).isActive = true
        self.headerView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.20, constant: 0).isActive = true
        
        // - Collection view
        self.view.addSubview(self.memberCollectionView)
        self.memberCollectionView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor).isActive = true
        self.memberCollectionView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor).isActive = true
        self.memberCollectionView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor).isActive = true
        self.memberCollectionView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.65).isActive = true
        
        // = Add the bottom menu
        self.view.addSubview(self.buttonMenu)
        self.topConstraint = self.buttonMenu.topAnchor.constraint(equalTo: self.view.bottomAnchor)
        self.topConstraint?.isActive = true
        self.botConstraint = self.buttonMenu.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        self.botConstraint?.isActive = false
        self.buttonMenu.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.buttonMenu.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.buttonMenu.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.14).isActive = true
    }
}
