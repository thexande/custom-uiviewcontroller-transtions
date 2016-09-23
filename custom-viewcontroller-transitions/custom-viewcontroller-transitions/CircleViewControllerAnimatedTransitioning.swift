//
//  CircleViewControllerAnimatedTransitioning.swift
//  custom-viewcontroller-transitions
//
//  Created by Joshua Alvarado on 9/22/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import UIKit

class CircleViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    let presenting: Bool
    
    init(isPresenting: Bool) {
        presenting = isPresenting
        super.init()
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey), fromViewVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey), containerView = transitionContext.containerView() else {
            return
        }
        
        if presenting {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: toViewVC.view.bounds.width, height: toViewVC.view.bounds.width))
            view.center = containerView.center
            view.backgroundColor = toViewVC.view.backgroundColor
            view.alpha = 1
            view.layer.cornerRadius = view.frame.height / 2
            
            containerView.addSubview(view)
            
            // when presenting
            containerView.addSubview(toViewVC.view)
            toViewVC.view.alpha = 0
            
            UIView.animateWithDuration(transitionDuration(transitionContext) / 3, animations: {
                view.transform = CGAffineTransformMakeScale(1.5, 1.5)
                }, completion: { completed in
                    UIView.animateWithDuration(self.transitionDuration(transitionContext) / 3, animations: {
                        view.transform = CGAffineTransformMakeScale(0.5, 0.5)
                        }, completion: { completed in
                            UIView.animateWithDuration(self.transitionDuration(transitionContext) / 3, animations: {
                                view.transform = CGAffineTransformMakeScale(3, 3)
                                view.alpha = 0
                                toViewVC.view.alpha = 1
                                }, completion: { completed in
                                    view.removeFromSuperview()
                                    transitionContext.completeTransition(completed)
                            })
                    })
            })
        } else {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: fromViewVC.view.bounds.height, height: fromViewVC.view.bounds.height))
            view.center = containerView.center
            view.backgroundColor = .whiteColor()
            view.alpha = 1
            view.layer.cornerRadius = view.frame.height / 2
            
            containerView.insertSubview(view, aboveSubview: fromViewVC.view)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
                view.transform = CGAffineTransformMakeScale(0.01, 0.01)
                view.alpha = 0
                }, completion: { completed in
                    view.removeFromSuperview()
                    transitionContext.completeTransition(completed)
            })
            
            // when dismiss
            containerView.insertSubview(toViewVC.view, belowSubview: fromViewVC.view)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.0
    }
    
    func animationEnded(transitionCompleted: Bool) {
        // clean up work
    }
}

// MARK: - UIViewControllerTransitioningDelegate

class PresentingViewControllerTransitionCoordinator: NSObject, UIViewControllerTransitioningDelegate {
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircleViewControllerAnimatedTransitioning(isPresenting: false)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CircleViewControllerAnimatedTransitioning(isPresenting: true)
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
