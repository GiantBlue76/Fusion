//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

extension UIFont {
    
    static var bodyLabel: UIFont? {
        get {
            return UIFont.init(name: "HelveticaNeue", size: 14.0)
        }
    }
    
    static var headerLabel: UIFont? {
        get {
            return UIFont.init(name: "HelveticaNeue-Medium", size: 15.0)
        }
    }
}

class EventsViewController: UIViewController {
    
    // - Next show view
    fileprivate lazy var nextShowView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.red.cgColor
        return view
    }()
    
    fileprivate lazy var nextShowLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.headerLabel
        label.text = "Next Show:"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    fileprivate lazy var nextShowImageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderColor = UIColor.red.cgColor
        imageView.layer.borderWidth = 1.0
        return imageView
    }()
    
    fileprivate lazy var nextShowEventSummaryLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bodyLabel
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.numberOfLines = 2
        label.text = "Fusion at Parmer Lane Tavern"
        return label
    }()
    
    fileprivate lazy var nextShowAddressLabel: UILabel = {
        let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.bodyLabel
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "1104 West Parmer Lane\nAustin, TX"
        return label
    }()
    
    fileprivate lazy var directionsButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Directions", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1.0
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // - Create autolayout constraints
        self.layout()
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

// MARK: - Private

fileprivate extension EventsViewController {
    func layout() {
        
        // - Layout the next show container view
        self.view.addSubview(self.nextShowView)
        self.nextShowView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.nextShowView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.nextShowView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        // - Layout the contents
        self.nextShowView.addSubview(self.nextShowImageView)
        self.nextShowImageView.topAnchor.constraint(equalTo: self.nextShowView.topAnchor, constant: 8.0).isActive = true
        self.nextShowImageView.leadingAnchor.constraint(equalTo: self.nextShowView.leadingAnchor, constant: 8.0).isActive = true
        self.nextShowImageView.trailingAnchor.constraint(equalTo: self.nextShowView.trailingAnchor, constant: -8.0).isActive = true
        self.nextShowImageView.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        
        self.nextShowView.addSubview(self.nextShowEventSummaryLabel)
        self.nextShowEventSummaryLabel.topAnchor.constraint(equalTo: self.nextShowImageView.bottomAnchor, constant: 4.0).isActive = true
        self.nextShowEventSummaryLabel.leadingAnchor.constraint(equalTo: self.nextShowImageView.leadingAnchor).isActive = true
        self.nextShowEventSummaryLabel.trailingAnchor.constraint(equalTo: self.nextShowImageView.trailingAnchor).isActive = true

        self.nextShowView.addSubview(self.nextShowAddressLabel)
        self.nextShowAddressLabel.topAnchor.constraint(equalTo: self.nextShowEventSummaryLabel.bottomAnchor, constant: 4.0).isActive = true
        self.nextShowAddressLabel.leadingAnchor.constraint(equalTo: self.nextShowImageView.leadingAnchor).isActive = true
        self.nextShowAddressLabel.trailingAnchor.constraint(equalTo: self.nextShowImageView.trailingAnchor).isActive = true

        self.nextShowView.addSubview(self.directionsButton)
        self.directionsButton.topAnchor.constraint(equalTo: self.nextShowAddressLabel.bottomAnchor, constant: 8.0).isActive = true
        self.directionsButton.heightAnchor.constraint(equalToConstant: 44.0)
        self.directionsButton.leadingAnchor.constraint(equalTo: self.nextShowImageView.leadingAnchor).isActive = true
        self.directionsButton.trailingAnchor.constraint(equalTo: self.nextShowImageView.trailingAnchor).isActive = true
        self.directionsButton.bottomAnchor.constraint(equalTo: self.nextShowView.bottomAnchor, constant: -8.0).isActive = true
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = EventsViewController.init()
