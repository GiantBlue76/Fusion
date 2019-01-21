//
//  EventsViewController.swift
//  Fusion
//
//  Created by Charles Imperato on 12/19/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import UIKit
import MessageUI
import UserNotifications
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

class EventsViewController: UIViewController, Shareable, Notifiable, UIPopoverPresentationControllerDelegate {
    // - Header view
    fileprivate lazy var bannerView: UIView = {
        let banner = UIView.init()
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.backgroundColor = UIColor.sharedBlue
        
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
        header.layer.borderColor = UIColor.sharedBlue.cgColor
        header.layer.borderWidth = 1.5
        
        let eventView = EventView()
        eventView.translatesAutoresizingMaskIntoConstraints = false
        eventView.backgroundColor = UIColor.clear
        eventView.tag = 100
        eventView.dateBoxView.backgroundColor = UIColor.white
        
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
    
    fileprivate let refresh = UIRefreshControl()
    
    // - The presenter for the view
    fileprivate let presenter: EventsPresenter

    // - Events for tableview
    fileprivate var events = [ViewEvent]() {
        didSet {
            self.tableView.reloadData()
            self.refresh.endRefreshing()
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
    
    // - The actions view
    fileprivate var overlayView: UIView?
    fileprivate var actionsView: EventActionsView?
    
    // MARK: - Shareable
    var supportedShareTypes: [ShareType] = [.email, .sms]
    
    // - Shareable data
    var shareData: Data?
    
    // - Shareable name
    var name: String? = "event"
    
    // - The mimetype for the message
    var mimeType: String?

    // - The body for the shareable message
    var body: String?
    
    // - The subject for the shareable
    var subject: String?
    
    // MARK: - Notifiable
    var notifyContainer: UIView?
    
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
    
    deinit {
        log.verbose("***** Deallocated view controller: \(EventsViewController.self) *****")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        // - Hide controls until data is loaded
        self.headerView.isHidden = true
        self.tableView.isHidden = true

        self.view.backgroundColor = UIColor.white
        self.title = "Upcoming Shows"
        
        self.refresh.tintColor = UIColor.red
        self.refresh.addTarget(self, action: #selector(refreshEvents), for: .valueChanged)
        self.tableView.refreshControl = self.refresh

        // - Register the cells for the table
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "eventCell")
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorInset = .zero
        
        // - Create autolayout constraints
        self.layout()
        
        Shared.dataCache.clear {
            DispatchQueue.main.async {
                // - Load the events
                self.presenter.loadEvents()
            }
        }
    }
    
    // MARK: - Actions
    @objc func refreshEvents() {
        self.presenter.refresh()
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        self.dismissActions()
    }
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
        cell.selectionStyle = .none
        
        // - Get the event for the index and configure the cell
        self.configureCell(cell, self.events[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter.select(indexPath.row)
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
        let listEvents = events
        self.nextEvent = listEvents.first
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
    
    func shareEvent(_ body: String, _ subject: String, data: Data, mimeType: String) {
        self.body = body
        self.subject = subject
        self.shareData = data
        self.mimeType = mimeType
        self.share()
    }
    
    func scheduleReminder(_ date: String, _ location: String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                log.error("Local notifications could not be enabled. \(error).")
                self.notify(message: "Local notifications could not be enabled. \(error).", 2.5, UIColor.sharedBlue)
            }
        
            guard granted == true else {
                log.warning("Local notifications are not permitted.")
                return
            }
            
            let weekday = Date.localWeekday(fromDate: date)
            let month = Date.localMonth(fromDate: date)
            let day = Date.dayFromUTCString(date)
            let year = Date.localYearFromDate(utc: date)
            let time = Date.localTimeFromDate(utc: date)

            // - Reminder date set to two days prior to the event
            guard let reminderDate = Date.dateFromUTCString(utc: date)?.addingTimeInterval(-1 * 24 * 60 * 60) else { return }

            // - Clear current reminders
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            // - Register for reminders
            let content = UNMutableNotificationContent()
            content.title = "Fusion Show Reminder"
            content.body = "Fusion has a show on \(weekday) \(month) \(day) \(year) at \(time) at \(location)"
            content.sound = UNNotificationSound.default
            
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: reminderDate)
            let trigger = UNCalendarNotificationTrigger.init(dateMatching: components, repeats: false)
            let request = UNNotificationRequest.init(identifier: "GIG_REMINDER", content: content, trigger: trigger)
            
            // - Schedule the reminder
            let center = UNUserNotificationCenter.current()
            center.add(request) { (error) in
                if let error = error {
                    self.notify(message: "The event reminder could not be scheduled. \(error)", 2.5, UIColor.sharedBlue)
                }
            }
        }
    }
    
    func showActions(_ presenter: EventActionsPresenter) {
        self.actions(presenter)
    }
    
    func showBanner(_ message: String) {
        DispatchQueue.main.async {
            self.notify(message: message, 5.0, UIColor.sharedBlue)
        }
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
        
        self.hideSpinner()
        
        // - Notify the user with any pertinent info
        controller.dismiss(animated: true) {
            if let message = message {
                let alert = UIAlertController.init(title: "Event Share", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else if result == .sent {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.notify(message: "This event was shared successfully.", 2.5, UIColor.sharedBlue)
                })
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
        
        self.hideSpinner()
        
        // - Notify the user that the email was sent
        controller.dismiss(animated: true) {
            if let message = message {
                let alert = UIAlertController.init(title: "Event Share", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else if result == .sent {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.notify(message: "This event was shared successfully.", 2.5, UIColor.sharedBlue)
                })
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
    
    func actions(_ presenter: EventActionsPresenter) {
        guard let actionsView = Bundle.main.loadNibNamed("EventActionsView", owner: nil, options: nil)?.first as? EventActionsView else {
            log.warning("Unable to load the event actions view.")
            return
        }
        
        let overlay = UIView.init()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlay.alpha = 0
        
        self.view.addSubview(overlay)
        overlay.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        overlay.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        overlay.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        overlay.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        actionsView.translatesAutoresizingMaskIntoConstraints = false
        actionsView.alpha = 0
        actionsView.presenter = presenter
        actionsView.mapButtonHandler = { [weak self] (type) in
            guard let selected = self?.tableView.indexPathForSelectedRow?.row else {
                return
            }
            
            self?.dismissActions()
            self?.presenter.map(type, selected)
        }
        
        actionsView.shareButtonHandler = { [weak self] in
            guard let indexPath = self?.tableView.indexPathForSelectedRow, let cell = self?.tableView.cellForRow(at: indexPath), let data = cell.viewWithTag(100)?.snapshot().pngData() else {
                return
            }
            
            self?.dismissActions()
            self?.presenter.share((data, "img/png"), indexPath.row)
        }
        
        actionsView.calendarButtonHandler = { [weak self] in
            guard let indexPath = self?.tableView.indexPathForSelectedRow else {
                return
            }
            
            self?.dismissActions()
            self?.presenter.addToCalendar(indexPath.row)
        }
        
        // - Display the view
        self.view.addSubview(actionsView)
        actionsView.widthAnchor.constraint(equalTo: overlay.widthAnchor, multiplier: UIDevice.current.sizeClass == .compact ? 0.8 : 0.6).isActive = true
        actionsView.centerXAnchor.constraint(equalTo: overlay.centerXAnchor).isActive = true
        actionsView.centerYAnchor.constraint(equalTo: overlay.centerYAnchor).isActive = true
        
        UIView.animate(withDuration: 0.15) {
            overlay.alpha = 1.0
            actionsView.alpha = 1.0
        }
        
        self.overlayView = overlay
        self.actionsView = actionsView
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapped(_:)))
        tap.numberOfTapsRequired = 1
        overlay.addGestureRecognizer(tap)
    }

    func dismissActions() {
        UIView.animate(withDuration: 0.15, animations: {
            self.actionsView?.alpha = 0
            self.overlayView?.alpha = 0
        }) { (finished) in
            self.actionsView?.removeFromSuperview()
            self.overlayView?.removeFromSuperview()
            self.actionsView = nil
            self.overlayView = nil
        }
    }
}
