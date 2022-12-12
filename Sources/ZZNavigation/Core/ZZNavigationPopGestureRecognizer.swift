//
//  ZZNavigationPopGestureRecognizer.swift
//  ZZNavigation
//
//  Created by Ethan on 2022/9/30.
//  Copyright © 2022 ZZNavigation. All rights reserved.
//

import UIKit

open class ZZNavigationPopGestureRecognizer: NSObject, UIGestureRecognizerDelegate {

    public weak var navigationController: ZZNavigationController?

    public lazy var panGestureRecognizer = UIPanGestureRecognizer()

    public var popInteractiveTransition: UIPercentDrivenInteractiveTransition?

    public override init() {
        super.init()
        commonInit()
    }

    private func commonInit() {
        panGestureRecognizer.delegate = self
        panGestureRecognizer.addTarget(self, action: #selector(handlePopRecognizer))
    }

    @objc private func handlePopRecognizer(recognizer: UIPanGestureRecognizer) {
        guard let navigationController = self.navigationController else {
            return
        }
        var progress = recognizer.translation(in: navigationController.view).x / navigationController.view.bounds.size.width
        let velocity = recognizer.velocity(in: navigationController.view)
        progress = min(1, max(0, progress))
        if recognizer.state == .began {
            popInteractiveTransition = UIPercentDrivenInteractiveTransition()
            navigationController.popViewController(animated: true)
        } else if recognizer.state == .changed {
            popInteractiveTransition?.update(progress)
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            if progress > 0.5 || velocity.x > 680 {
                popInteractiveTransition?.update(progress > 0.5 ? 0.5 : progress)
                popInteractiveTransition?.finish()
            } else {
                popInteractiveTransition?.update(progress < 0.5 ? 0.5 : progress)
                popInteractiveTransition?.cancel()
            }
            popInteractiveTransition = nil
        }
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationController = self.navigationController else {
            return false
        }
        if (navigationController.topViewController as? ZZViewController)?.navigationPopGestureEnabled == false {
            return false
        }
        if navigationController.viewControllers.count <= 1 {
            return false
        }
        if (navigationController.value(forKey: "_isTransitioning") as? Bool) == true {
            return false
        }
        if let panGR = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGR.translation(in: nil)
            return translation.x > 0 && (abs(translation.x) > abs(translation.y))
        }
        return true
    }
}
