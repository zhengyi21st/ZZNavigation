//
//  ZZAnimatedTransitioning.swift
//  ZZNavigation
//
//  Created by Ethan on 2022/9/30.
//  Copyright © 2022 ZZNavigation. All rights reserved.
//

import UIKit

open class ZZAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    public enum Operation: Int {
        case appear = 0
        case disappear = 1
    }

    open var operation: Operation

    public required init(operation: Operation) {
        self.operation = operation
    }

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ZZNavigation.defaultAnimationDuration
    }

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if operation == .appear {
            animateTransitionForAppear(using: transitionContext)
        } else {
            animateTransitionForDisappear(using: transitionContext)
        }
    }

    open func animateTransitionForAppear(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(false)
    }

    open func animateTransitionForDisappear(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(false)
    }
}
