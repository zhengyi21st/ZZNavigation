//
//  ZZPresentAnimatedTransitioning.swift
//  ZZNavigation
//
//  Created by Ethan on 2022/9/30.
//  Copyright © 2022 ZZNavigation. All rights reserved.
//

import UIKit

open class ZZPresentAnimatedTransitioning: ZZAnimatedTransitioning {

    public override func animateTransitionForAppear(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        if toVC.view.superview == nil {
            transitionContext.containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
        }

        toVC.view.frame.origin.y = toVC.view.frame.height
        let options =  transitionContext.isInteractive ? .curveLinear : ZZNavigation.defaultAnimationOptions
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: options) {
            toVC.view.frame.origin.y = 0
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            toVC.view.frame.origin.y = 0
        }
    }

    public override func animateTransitionForDisappear(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        fromVC.view.updateConstraintsIfNeeded()
        toVC.view.updateConstraintsIfNeeded()
        if toVC.view.superview == nil {
            transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        toVC.view.frame = transitionContext.containerView.bounds
        fromVC.view.frame.origin.y = 0

        let options =  transitionContext.isInteractive ? .curveLinear : ZZNavigation.defaultAnimationOptions
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: options) {
            fromVC.view.frame.origin.y = fromVC.view.frame.height
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.view.frame.origin.y = 0
        }
    }
}
