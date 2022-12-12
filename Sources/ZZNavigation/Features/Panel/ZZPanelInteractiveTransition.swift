//
//  ZZPanelInteractiveTransition.swift
//  ZZNavigation
//
//  Created by Ethan on 2022/9/30.
//  Copyright © 2022 ZZNavigation. All rights reserved.
//

import UIKit

open class ZZPanelInteractiveTransition: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {

    public weak var viewController: ZZViewController?

    public weak var scrollView: UIScrollView?

    public weak var contentView: UIView?

    public lazy var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePopRecognizer(_:)))

    public var isProgress = false

    private var shouldCompleteTransition = false

    private var startTransitionY: CGFloat = 0

    public override init() {
        super.init()
        panGestureRecognizer.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: panGestureRecognizer.view)
            let isVertical =  abs(translation.x) < abs(translation.y)
            return isVertical
        }
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer == scrollView?.panGestureRecognizer {
            return true
        }
        return false
    }

    public func track(viewController: ZZViewController?, contentView: UIView?) {
        self.viewController = viewController
        self.contentView = contentView
        contentView?.addGestureRecognizer(panGestureRecognizer)
    }

    public func untrack(contentView: UIView?) {
        self.viewController = nil
        self.scrollView = nil
        self.contentView = nil
        if contentView?.gestureRecognizers?.contains(panGestureRecognizer) == true {
            contentView?.removeGestureRecognizer(panGestureRecognizer)
        }
    }

    @objc func handlePopRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            break
        case .changed:
            let translation = gestureRecognizer.translation(in: gestureRecognizer.view!)
            let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view!)
            var rawProgress = CGFloat(0.0)
            rawProgress = ((translation.y - startTransitionY) / gestureRecognizer.view!.bounds.size.height)
            let progress = CGFloat(fminf(fmaxf(Float(rawProgress), 0.0), 1.0))
            if abs(velocity.x) > abs(velocity.y) { return }
            if scrollView?.panGestureRecognizer.state != .possible, let scrollView = self.scrollView, scrollView.contentOffset.y > 0 {
                return
            }
            if !isProgress {
                isProgress = true
                startTransitionY = translation.y
                startTrack()
            } else {
                shouldCompleteTransition = progress > 0.5 || velocity.y > 680
                update(progress)
            }
        case .ended:
            isProgress = false
            startTransitionY = 0
            if shouldCompleteTransition {
                update(percentComplete > 0.5 ? 0.5 : percentComplete)
                finish()
            } else {
                update(percentComplete < 0.5 ? 0.5 : percentComplete)
                cancel()
            }
            endTrack()
        case .failed, .cancelled:
            isProgress = false
            startTransitionY = 0
            update(percentComplete < 0.5 ? 0.5 : percentComplete)
            cancel()
            endTrack()
        default:
            break
        }
    }

    private func startTrack() {
        viewController?.dismissTransition = self
        viewController?.dismiss(animated: true, completion: nil)

    }

    private func endTrack() {
        viewController?.dismissTransition = nil
    }
}
