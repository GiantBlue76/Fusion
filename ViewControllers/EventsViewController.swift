//
//  EventsViewController.swift
//  Fusion
//
//  Created by Charles Imperato on 12/19/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import UIKit
import MessageUI
import wvslib

// - Event type for use within the table view
struct ViewEvent {
    let day: String
    let month: String
    let date: String
    let time: String
    let venue: String
    let address: String
    let summary: String
    let posterUrl: String
}

class EventsViewController: UIViewController, Shareable, UIPopoverPresentationControllerDelegate {
    // - Header view
    fileprivate lazy var bannerView: UIView = {
        let banner = UIView.init()
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.backgroundColor = UIColor.colorWithHexValue(hex: "329e27", alpha: 1.0)
        
        let bannerLabel = UILabel.init()
        bannerLabel.translatesAutoresizingMaskIntoConstraints = false
        bannerLabel.font = UIFont.bodyLabel
        bannerLabel.textColor = UIColor.white
        bannerLabel.text = "Next Gig"
        
        banner.addSubview(bannerLabel)
        bannerLabel.topAnchor.constraint(equalTo: banner.topAnchor, constant: 4.0).isActive = true
        bannerLabel.leadingAnchor.constraint(equalTo: banner.leadingAnchor, constant: 4.0).isActive = true
        bannerLabel.trailingAnchor.constraint(equalTo: banner.trailingAnchor, constant: -4.0).isActive = true
        bannerLabel.bottomAnchor.constraint(equalTo: banner.bottomAnchor, constant: -4.0).isActive = true
        return banner
    }()
    
    fileprivate lazy var headerView: UIView = {
        let header = UIView.init()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.backgroundColor = UIColor.white
        header.layer.borderColor = UIColor.darkGray.cgColor
        header.layer.borderWidth = 0.5
        
        let eventView = EventView()
        eventView.translatesAutoresizingMaskIntoConstraints = false
        eventView.backgroundColor = UIColor.clear
        eventView.tag = 100
        eventView.dateBoxView.backgroundColor = UIColor.white
        eventView.mapButtonHandler = { [weak self] (type) in
            self?.presenter.map(type, 0)
        }
        eventView.shareButtonHandler = { [weak self] (shareable) in
            self?.presenter.share(shareable, 0)
        }
        
        // - Add the event to the header
        header.addSubview(eventView)
        eventView.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        eventView.leadingAnchor.constraint(equalTo: header.leadingAnchor).isActive = true
        eventView.trailingAnchor.constraint(equalTo: header.trailingAnchor).isActive = true
        eventView.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -8.0).isActive = true
        
        // - Add the next gig banner
        header.addSubview(self.bannerView)
        self.bannerView.topAnchor.constraint(equalTo: eventView.posterImageView.topAnchor, constant: 8.0).isActive = true
        self.bannerView.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 4.0).isActive = true
        return header
    }()
    
    // - Error view
    fileprivate lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // - Table view for event list
    fileprivate lazy var tableView: UITableView = {
        let table = UITableView.init(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = UIColor.clear
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    // - The presenter for the view
    fileprivate let presenter: EventsPresenter

    // - Events for tableview
    fileprivate var events = [ViewEvent]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // - Next event
    fileprivate var nextEvent: ViewEvent? {
        didSet {
            guard let nextEvent = self.nextEvent, let eventView = self.headerView.viewWithTag(100) as? EventView else {
                return
            }
            
            self.configureEventView(nextEvent, eventView)
        }
    }
    
    // MARK: - Shareable

    var supportedShareTypes: [ShareType] = [.sms]
    
    // - Shareable data
    var shareData: Data?
    
    // - Shareable name
    var name: String? = "event"
    
    // - The mimetype for the message
    var mimeType: String?

    // - The body for the shareable message
    var body: String?
    
    init(withPresenter presenter: EventsPresenter) {
        self.presenter = presenter

        // - Call the super and assign the delegate
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }
    
    private init() {
        self.presenter = EventsPresenter()
        
        // - Invoke super initializer
        super.init(nibName: nil, bundle: nil)
        self.presenter.delegate = self
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.presenter = EventsPresenter()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // - Hide controls until data is loaded
        self.headerView.isHidden = true
        self.tableView.isHidden = true

        self.view.backgroundColor = UIColor.white
        self.title = "Upcoming Shows"

        // - Register the cells for the table
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "eventCell")
        self.tableView.separatorStyle = .none
        self.tableView.separatorInset = .zero

        // - Create autolayout constraints
        self.layout()
        
        DispatchQueue.main.async {
            // - Load the events
            self.presenter.loadEvents()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDatasource, UITableViewDelegate

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        // - Get the event for the index and configure the cell
        self.configureCell(cell, self.events[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // - Private
    
    private func configureCell(_ cell: UITableViewCell, _ event: ViewEvent) {
        // - Reuse the event view from the content view if it is already there
        var eventView = EventView.init()
        if let view = cell.viewWithTag(100) as? EventView {
            eventView = view
        }
        else {
            // - Create a new event view and add constraints
            cell.addSubview(eventView)
            eventView.translatesAutoresizingMaskIntoConstraints = false
            eventView.tag = 100
            eventView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            eventView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
            eventView.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
            eventView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -20.0).isActive = true
            eventView.mapButtonHandler = { [weak self] (type) in
                guard let indexPath = self?.tableView.indexPath(for: cell) else {
                    log.warning("The index path could not be found for the cell to invoke the map button.")
                    return
                }
                self?.presenter.map(type, indexPath.row + 1)
            }
            eventView.shareButtonHandler = { [weak self] (shareable) in
                guard let indexPath = self?.tableView.indexPath(for: cell) else {
                    log.warning("The index path could not be found for the cell to invoke the map button.")
                    return
                }
                self?.presenter.share(shareable, indexPath.row + 1)
            }
        }

        // - Handle map selection
        self.configureEventView(event, eventView)
    }
}

// MARK: - EventsDelegate

extension EventsViewController: EventsDelegate {
    func eventsLoaded(_ events: [ViewEvent]) {
        self.errorView.removeFromSuperview()
        self.tableView.isHidden = false
        self.headerView.isHidden = false
        
        // - Remove the first event (most current) and use that for the header
        var listEvents = events
        self.nextEvent = listEvents.removeFirst()
        self.events = listEvents
    }
    
    func eventsLoadFailed(_ message: String) {
        self.view.addSubview(self.errorView)
        self.errorView.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
        self.errorView.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor).isActive = true
        self.errorView.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor).isActive = true
        self.errorView.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor).isActive = true
        
        // - Update the text and bring to front
        self.errorView.text = message
        self.view.bringSubviewToFront(self.errorView)
    }
    
    func openMaps(_ appleMap: URL?, _ googleMap: URL?) {
        if let apple = appleMap, let google = googleMap {
            let alert = UIAlertController.init(title: "Navigate", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction.init(title: "Apple Maps", style: .default) { (action) in
                UIApplication.shared.open(apple, options: [:])
            })
            
            alert.addAction(UIAlertAction.init(title: "Google Maps", style: .default, handler: { (action) in
                UIApplication.shared.open(google, options: [:])
            }))
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        }
        else if let google = googleMap {
            UIApplication.shared.open(google, options: [:])
        }
        else if let apple = appleMap {
            UIApplication.shared.open(apple, options: [:])
        }
    }
    
    func shareEvent(_ body: String, data: Data, mimeType: String) {
        self.body = body
        self.shareData = data
        self.mimeType = mimeType
        self.share()
    }
}

// MARK: - MFMessageComposeViewControllerDelegate

extension EventsViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        var message: String?
        switch result {
            case .failed:
                message = "The event could not be sent.  Please try again later."
            
            case .sent:
                fallthrough
            
            default:
                break
        }
        
        // - Notify the user with any pertinent info
        controller.dismiss(animated: true) {
            if let message = message {
                let alert = UIAlertController.init(title: "Event Share", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension EventsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var message: String?
        switch result {
            case .failed:
                message = "This event could not be sent. \(error?.localizedDescription ?? "")"
            
            case .sent:
                fallthrough
            
            default:
                break
        }
        
        // - Notify the user that the email was sent
        controller.dismiss(animated: true) {
            if let message = message {
                let alert = UIAlertController.init(title: "Event Share", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Private

fileprivate extension EventsViewController {
    func layout() {
        // - Add the header
        self.view.addSubview(self.headerView)
        self.headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.headerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.headerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        // - Add the table view
        self.view.addSubview(self.tableView)
        self.tableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func configureEventView(_ event: ViewEvent, _ eventView: EventView) {
        eventView.addressLabel.text = event.address
        eventView.summaryLabel.text = event.summary
        eventView.venueImageView.fetchImage(event.posterUrl)
        
        // - Format the attributed text for the date box
        let normal = [
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.font: UIFont.bodyLabel
        ]
        
        let attributed = [
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.font: UIFont.headerLabel
        ]
        
        let nsas = NSMutableAttributedString.init(string: "\(event.date)", attributes: normal)
        nsas.append(NSMutableAttributedString.init(string: "\n\(event.month) \(event.day)", attributes: attributed))
        nsas.append(NSMutableAttributedString.init(string: "\n\(event.time)", attributes: normal))
        eventView.dateLabel.attributedText = nsas
    }
}
