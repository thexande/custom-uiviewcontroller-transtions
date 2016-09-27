//
//  ViewController.swift
//  custom-viewcontroller-transitions
//
//  Created by Joshua Alvarado on 9/22/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let presentingCoordinator = PresentingViewControllerTransitionCoordinator()
    let interactiveCoordinator = CircleInteractiveController()
    
    lazy var swipeGesture: UIPinchGestureRecognizer = {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(handleGesture))
        return gesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(swipeGesture)
    }
    
    @IBAction func presentModal(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalPresentationViewControllerId")
        vc.transitioningDelegate = presentingCoordinator
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func handleGesture(sender: UIPinchGestureRecognizer) {
        if sender.state == .Began {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalPresentationViewControllerId")
            vc.transitioningDelegate = presentingCoordinator
            presentingCoordinator.interactive = interactiveCoordinator
            presentViewController(vc, animated: true, completion: nil)
        }
        interactiveCoordinator.handleGesture(sender)
    }
}
