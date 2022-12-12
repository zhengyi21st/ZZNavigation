//
//  ZZNavigationController.swift
//  ZZNavigation
//
//  Created by Ethan on 2022/9/30.
//  Copyright © 2022 ZZNavigation. All rights reserved.
//

import UIKit

open class ZZNavigationController: UINavigationController {

    public lazy var popGestureRecognizer = ZZNavigationPopGestureRecognizer()

    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }

    open override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        delegate = self
        popGestureRecognizer.navigationController = self
        interactivePopGestureRecognizer?.isEnabled = false
        interactivePopGestureRecognizer?.view?.addGestureRecognizer(popGestureRecognizer.panGestureRecognizer)
    }

    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if let visibleVC = visibleViewController as? ZZViewController {
            findFirstResponder(view: visibleVC.view)?.resignFirstResponder()
        }
        super.pushViewController(viewController, animated: animated)
    }

    @discardableResult open override func popViewController(animated: Bool) -> UIViewController? {
        if let visibleVC = visibleViewController as? ZZViewController {
            visibleVC.lastResponder = findFirstResponder(view: visibleVC.view)
            visibleVC.lastResponder?.resignFirstResponder()
        }
        return super.popViewController(animated: animated)
    }

    private func findFirstResponder(view: UIView) -> UIResponder? {
        guard view.isFirstResponder != true else { return view }
        for subview in view.subviews {
            if let firstResponder = findFirstResponder(view: subview) {
                return firstResponder
            }
        }
        return nil
    }
}

// MARK: - UINavigationControllerDelegate

extension ZZNavigationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return popGestureRecognizer.popInteractiveTransition
    }

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            return (fromVC as? ZZViewController)?.navigationAnimatedTransitioningCls.init(operation: .disappear) ?? ZZStackAnimatedTransitioning(operation: .disappear)
        } else {
            return (toVC as? ZZViewController)?.navigationAnimatedTransitioningCls.init(operation: .appear) ?? ZZStackAnimatedTransitioning(operation: .disappear)
        }
    }
}
