//
//  CurlUpViewControllerAnimatedTransitioning.swift
//  custom-viewcontroller-transitions
//
//  Created by Joshua Alvarado on 9/22/16.
//  Copyright © 2016 Joshua Alvarado. All rights reserved.
//

import UIKit

class CurlUpViewControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
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
            let view = fromViewVC.view.snapshotViewAfterScreenUpdates(true)
            containerView.addSubview(view)
            containerView.insertSubview(toViewVC.view, belowSubview: view)
            
            UIView.transitionFromView(view, toView: toViewVC.view, duration: transitionDuration(transitionContext), options: .TransitionCurlUp, completion: {completed in
                view.removeFromSuperview()
                // when presenting
                transitionContext.completeTransition(completed)
            })
        } else {
            // when dismiss
            containerView.insertSubview(toViewVC.view, belowSubview: fromViewVC.view)
        }
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2.0
    }
    
    func animationEnded(transitionCompleted: Bool) {
        // clean up
    }
}
