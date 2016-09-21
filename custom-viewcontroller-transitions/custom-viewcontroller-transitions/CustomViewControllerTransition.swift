//
//  CustomViewControllerTransition.swift
//  custom-viewcontroller-transitions
//
//  Created by Joshua Alvarado on 9/21/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIViewControllerAnimatedTransitioning

/// Animates the transition of a small circular view in the bottom right corner that scales up in size to reveal the view controller underneath in the transition.
class CircleViewControllerAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let presenting: Bool
    
    var context: UIViewControllerContextTransitioning?
    var maskingLayer: CALayer?
    
    init(presenting: Bool) {
        self.presenting = presenting
        super.init()
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey), let fromViewVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey), containerView = transitionContext.containerView() else {
            return
        }
        
        context = transitionContext
        
        if presenting {
            containerView.addSubview(toViewVC.view)
            
            toViewVC.view.frame = fromViewVC.view.frame
            
            let maskLayer = CAShapeLayer()
            let circlePath = UIBezierPath(ovalInRect: CGRect(x: toViewVC.view.frame.maxX - 200, y: toViewVC.view.frame.maxY - 200, width: 400, height: 400))
            maskLayer.path = circlePath.CGPath
            maskLayer.frame = toViewVC.view.frame
            
            toViewVC.view.layer.mask = maskLayer
            
            let endFrame = CGRect(x: -150, y: -150, width: toViewVC.view.frame.width *  3, height: toViewVC.view.frame.width * 3)
            let endFramePath = UIBezierPath(ovalInRect: endFrame)
            
            maskingLayer = maskLayer
            
            let pathAnimation = CABasicAnimation(keyPath: "path")
            //            pathAnimation.fromValue = circlePath.CGPath
            pathAnimation.toValue = endFramePath
            pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            pathAnimation.duration = transitionDuration(transitionContext)
            maskLayer.path = endFramePath.CGPath
            maskLayer.addAnimation(pathAnimation, forKey: "pathAnimation")
            
        } else {
            toViewVC.view.frame = fromViewVC.view.frame
            containerView.addSubview(toViewVC.view)
            containerView.insertSubview(fromViewVC.view, aboveSubview: toViewVC.view)
            
            let maskLayer = CAShapeLayer()
            let circlePath = UIBezierPath(ovalInRect: CGRect(x: -150, y: -150, width: fromViewVC.view.frame.width * 3.0, height: fromViewVC.view.frame.width * 3.0))
            maskLayer.path = circlePath.CGPath
            maskLayer.frame = toViewVC.view.frame
            
            fromViewVC.view.layer.mask = maskLayer
            fromViewVC.view.clipsToBounds = true
            
            let endFrame = CGRect(x: toViewVC.view.frame.maxX - 100, y: toViewVC.view.frame.maxY - 100, width: 200, height: 200)
            
            let bigCirclePath = UIBezierPath(ovalInRect: endFrame)
            
            maskingLayer = maskLayer
            
            let pathAnimation = CABasicAnimation(keyPath: "path")
            //            pathAnimation.fromValue = circlePath.CGPath
            pathAnimation.toValue = bigCirclePath
            pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            pathAnimation.duration = transitionDuration(transitionContext)
            
            maskLayer.path = bigCirclePath.CGPath
            maskLayer.addAnimation(pathAnimation, forKey: "pathAnimation")
        }
    }
    
    /*
     override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
     maskingLayer?.removeFromSuperlayer()
     context?.completeTransition(true)
     context = nil
     }
     */
    func animationEnded(transitionCompleted: Bool) {
        // animation has ended
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
}

// MARK: - UIViewControllerTransitioningDelegate

class CustomViewControllerTransitionCoordinator: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircleViewControllerAnimatedTransition(presenting: false)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircleViewControllerAnimatedTransition(presenting: true)
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return nil
    }
    
}

extension UIViewController {
    /// Display an animating `UIActivityIndicatorView` in the `rightBarButtonItem` of the `UINavigationItem`
    func animateRightBarButtonItem() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        activityIndicator.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        return activityIndicator
    }
}