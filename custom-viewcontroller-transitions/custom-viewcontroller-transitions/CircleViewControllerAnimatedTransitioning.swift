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
            let circleViewWidth = toViewVC.view.bounds.width / 2
            
            let circleView = UIView(frame: CGRect(x: toViewVC.view.bounds.midX - (circleViewWidth / 2), y: toViewVC.view.bounds.maxY, width: circleViewWidth, height: circleViewWidth))
            circleView.backgroundColor = toViewVC.view.backgroundColor
            circleView.layer.cornerRadius = circleView.frame.height / 2
            
            containerView.addSubview(circleView)
            containerView.addSubview(toViewVC.view)
            toViewVC.view.alpha = 0
            
            let relativeKeyFrameDuration = 1.0 / 3
            UIView.animateKeyframesWithDuration(transitionDuration(transitionContext), delay: 0.0, options: .CalculationModeLinear, animations: {
                UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: relativeKeyFrameDuration, animations: {
                    circleView.center = toViewVC.view.center
                })
                UIView.addKeyframeWithRelativeStartTime(0.3, relativeDuration: relativeKeyFrameDuration, animations: {
                    circleView.transform = CGAffineTransformMakeScale(0.5, 0.5)
                })
                UIView.addKeyframeWithRelativeStartTime(0.6, relativeDuration: relativeKeyFrameDuration, animations: {
                    circleView.transform = CGAffineTransformMakeScale(10, 10)
                    toViewVC.view.alpha = 1
                })
            }, completion: { completed in
                circleView.removeFromSuperview()
                transitionContext.completeTransition(completed)
            })
        } else {
            let maskViewHeight = fromViewVC.view.bounds.height * 1.1
            let maskView = UIView(frame: CGRect(x: 0, y: 0, width: maskViewHeight, height: maskViewHeight))
            maskView.center = containerView.center
            maskView.backgroundColor = fromViewVC.view.backgroundColor
            maskView.alpha = 1
            maskView.layer.cornerRadius = maskView.frame.height / 2
            
            containerView.insertSubview(maskView, aboveSubview: fromViewVC.view)
            fromViewVC.view.alpha = 0
            
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, options: .CurveLinear, animations: {
                maskView.transform = CGAffineTransformMakeScale(0.01, 0.01)
            }, completion: { completed in
                    maskView.removeFromSuperview()
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
