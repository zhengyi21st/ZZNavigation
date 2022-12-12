//
//  ZZStackAnimatedTransitioning.swift
//  ZZNavigation
//
//  Created by Ethan on 2022/9/30.
//  Copyright © 2022 ZZNavigation. All rights reserved.
//

import UIKit

open class ZZStackAnimatedTransitioning: ZZAnimatedTransitioning {

    public override func animateTransitionForAppear(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        if toVC.view.superview == nil {
            transitionContext.containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
        }
        toVC.view.frame.origin.x = toVC.view.frame.width

        let dimmingView = UIView(frame: fromVC.view.bounds)
        dimmingView.backgroundColor = .black
        dimmingView.alpha = 0
        transitionContext.containerView.insertSubview(dimmingView, belowSubview: toVC.view)
        let options = transitionContext.isInteractive ? .curveLinear : ZZNavigation.defaultAnimationOptions
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: options) {
            toVC.view.frame.origin.x = 0
            fromVC.view.frame.origin.x = -fromVC.view.bounds.width * 0.3
            dimmingView.alpha = 0.1
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            dimmingView.removeFromSuperview()
            toVC.view.frame.origin.x = 0
            fromVC.view.frame.origin.x = 0
        }
    }

    public override func animateTransitionForDisappear(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        if toVC.view.superview == nil {
            transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        toVC.view.frame.origin.x = -toVC.view.bounds.width * 0.3

        let dimmingView = UIView(frame: toVC.view.bounds)
        dimmingView.backgroundColor = .black
        dimmingView.alpha = 0.1
        transitionContext.containerView.insertSubview(dimmingView, belowSubview: fromVC.view)

        let options =  transitionContext.isInteractive ? .curveLinear : ZZNavigation.defaultAnimationOptions
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: options) {
            toVC.view.frame.origin.x = 0
            fromVC.view.frame.origin.x = fromVC.view.frame.width
            dimmingView.alpha = 0
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            dimmingView.removeFromSuperview()
            toVC.view.frame.origin.x = 0
            fromVC.view.frame.origin.x = 0
        }
    }
}
