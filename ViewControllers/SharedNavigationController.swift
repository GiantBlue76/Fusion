//
//  SharedNavigationController.swift
//  Fusion
//
//  Created by Charles Imperato on 12/24/18.
//  Copyright © 2018 Wind Valley Software. All rights reserved.
//

import UIKit
import wvslib

class SharedNavigationController: UINavigationController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIDevice.current.sizeClass == .compact ? .portrait : [.portrait, .landscape]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // - Update the navigation bar for each view controller in the navigation stack
        self.viewControllers.forEach { (controller) in
            self.addNavigationButtons(controller)
        }
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        
        viewControllers.forEach { (controller) in
            self.addNavigationButtons(controller)
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
    
    fileprivate func addNavigationButtons(_ controller: UIViewController) {
        let backItem = UIBarButtonItem.init(image: CommonImages.back.image?.resizedImage(newSize: CGSize(width: 28.0, height: 28.0)), style: .plain, target: self, action: #selector(back))
        backItem.tintColor = UIColor.sharedBlue
        
        // - If this is the first view controller on the stack then we don't add the back button
        if self.viewControllers.first != controller {
            controller.navigationItem.leftBarButtonItem = backItem
            controller.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.sharedBlue]
        }
    }
    
    // - Back button handler
    @objc fileprivate func back() {
        self.popViewController(animated: true)
    }
}

// MARK: - UINavigationBarDelegate

extension SharedNavigationController: UINavigationBarDelegate {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        // - Add the navigation buttons when a view controller is pushed
        self.addNavigationButtons(viewController)
    }
}
