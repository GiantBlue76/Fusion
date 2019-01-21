//
//  EventActionsView.swift
//  Fusion
//
//  Created by Charles Imperato on 1/19/19.
//  Copyright © 2019 Wind Valley Software. All rights reserved.
//

import UIKit
import MapKit
import wvslib

class EventActionsView: UIView {

    // - Outlets
    @IBOutlet fileprivate var mapView: MKMapView!
    @IBOutlet fileprivate var addToCalendarButton: UIButton!
    @IBOutlet fileprivate var navigationButton: UIButton!
    @IBOutlet fileprivate var shareButton: UIButton!
    @IBOutlet fileprivate var buttons: [UIButton]!
    @IBOutlet fileprivate var labels: [UILabel]!
    
    // - Presenter
    var presenter: EventActionsPresenter? {
        didSet {
            self.presenter?.delegate = self
            self.presenter?.loadMap()
        }
    }
    
    fileprivate lazy var errorView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor.darkText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        
        view.addCoveringSubview(label)
        return view
    }()
    
    // - Handler for when the map button is tapped
    var mapButtonHandler: ((_ type: MapButtonType) -> ())?
    
    // - Handler for when the share button is tapped
    var shareButtonHandler: (() -> ())?
    
    // - Handler for when the calendar button is tapped
    var calendarButtonHandler: (() -> ())?
    
    // - Handler for when the share button
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.labels.forEach { (label) in
            label.textColor = UIColor.sharedBlue
        }
        
        self.buttons.forEach { (button) in
            button.clipsToBounds = true
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.sharedBlue.cgColor
            button.setBackgroundColor(UIColor.white, forState: .normal)
            button.setBackgroundColor(UIColor.lightGray, forState: .highlighted)
            button.setImage(button.image(for: .normal)?.resizedImage(newSize: CGSize.init(width: 32.0, height: 32.0))?.maskedImage(with: UIColor.sharedBlue), for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.async {
            self.addToCalendarButton.layer.cornerRadius = self.addToCalendarButton.bounds.width / 2.0
            self.navigationButton.layer.cornerRadius = self.navigationButton.bounds.width / 2.0
            self.shareButton.layer.cornerRadius = self.shareButton.bounds.width / 2.0
        }
    }
    
    // - Actions
    @IBAction func handleMapTap(_ sender: UIButton) {
        self.mapButtonHandler?(UIApplication.shared.supportedMaps())
    }
    
    @IBAction func handleShareTap(_ sender: UIButton) {
        self.shareButtonHandler?()
    }
    
    @IBAction func handleCalendarTap(_ sender: UIButton) {
        self.calendarButtonHandler?()
    }
}

// MARK: - EventActionsDelegate
extension EventActionsView: EventActionsDelegate {
    func addedToCalendar() {

    }
    
    func showShare() {
        
    }
    
    func showNavigation() {
        
    }
    
    func showMapError(_ message: String?) {
        if let label = self.errorView.subviews.filter({ return $0 is UILabel }).first as? UILabel {
            label.text = message
            self.mapView.addCoveringSubview(self.errorView)
        }
    }
    
    func mapLoaded(_ location: (latitude: Double, longitude: Double), _ title: String?) {
        var span = MKCoordinateSpan.init()
        span.latitudeDelta = 0.01
        span.longitudeDelta = 0.01
        
        let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D.init(latitude: location.0, longitude: location.1), span: span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsBuildings = true
        self.mapView.showsUserLocation = true
        
        let pin = MKPointAnnotation.init()
        pin.title = title
        pin.coordinate = CLLocationCoordinate2D.init(latitude: location.0, longitude: location.1)

        self.mapView.addAnnotation(pin)
    }
}
