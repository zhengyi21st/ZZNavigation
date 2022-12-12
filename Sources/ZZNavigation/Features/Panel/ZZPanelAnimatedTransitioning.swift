//
//  ZZPanelAnimatedTransitioning.swift
//  ZZNavigation
//
//  Created by Ethan on 2022/9/30.
//  Copyright © 2022 ZZNavigation. All rights reserved.
//

import UIKit

open class ZZPanelAnimatedTransitioning: ZZAnimatedTransitioning {

    public override func animateTransitionForAppear(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) as? ZZPanelViewController else {
            transitionContext.completeTransition(false)
            return
        }
        if toVC.view.superview == nil {
            transitionContext.containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
        }
        toVC.backgroundView.alpha = 0
        toVC.contentView.transform = CGAffineTransform(translationX: 0, y: toVC.contentSize.height)
        let options =  transitionContext.isInteractive ? .curveLinear : ZZNavigation.defaultAnimationOptions
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: options) {
            toVC.backgroundView.alpha = 1
            toVC.contentView.transform = CGAffineTransform(translationX: 0, y: 0)
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            toVC.contentView.transform = CGAffineTransform.identity
        }
    }

    public override func animateTransitionForDisappear(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from)  as? ZZPanelViewController,
              let toVC = transitionContext.viewController(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        if toVC.view.superview == nil {
            transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        let options =  transitionContext.isInteractive ? .curveLinear : ZZNavigation.defaultAnimationOptions
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: options) {
            fromVC.backgroundView.alpha = 0
            fromVC.contentView.transform = CGAffineTransform(translationX: 0, y: fromVC.contentSize.height)
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            fromVC.backgroundView.alpha = 1
            fromVC.contentView.transform = CGAffineTransform.identity
        }
    }
}
