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
    @IBAction func presentModal(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ModalPresentationViewControllerId")
        vc.transitioningDelegate = presentingCoordinator
        presentViewController(vc, animated: true, completion: nil)
    }
}
