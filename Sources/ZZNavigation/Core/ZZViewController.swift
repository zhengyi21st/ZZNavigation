//
//  ZZViewController.swift
//  ZZNavigation
//
//  Created by Ethan on 2022/9/30.
//

import UIKit
import ZZComponents

open class ZZViewController: UIViewController {

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .fullScreen
        transitioningDelegate = self
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        modalPresentationStyle = .fullScreen
        transitioningDelegate = self
    }

    deinit {
        print("♻️ [ZZNavigation]: deinit \(type(of: self))")
    }

    public lazy var navigationBar = ZZNavigationBar()

    open var navigationPopGestureEnabled = true

    open var navigationAnimatedTransitioningCls: ZZAnimatedTransitioning.Type = ZZStackAnimatedTransitioning.self

    open var presentAnimatedTransitioningCls: ZZAnimatedTransitioning.Type = ZZPresentAnimatedTransitioning.self

    weak var lastResponder: UIResponder?

    public var dismissTransition: UIPercentDrivenInteractiveTransition?
    
    open var navigationBarContentHeight: CGFloat = 49 {
        didSet {
            view.layoutSubviews()
        }
    }
    
    open override var title: String? {
        didSet {
            navigationBar.titleLabel.text = title
            navigationBar.layoutSubviews()
        }
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(navigationBar)
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: navigationBarContentHeight + view.safeAreaInsets.top)
        navigationBar.layoutSubviews()
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationBar.backButton.addTarget(self, action: #selector(handlePopAction), for: .touchUpInside)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.lastResponder?.becomeFirstResponder()
            self.lastResponder = nil
        }
    }

    private func setupUI() {
        view.backgroundColor = ZZColor.background
        view.addSubview(navigationBar)
        if let navCount = navigationController?.viewControllers.count, navCount > 1 {
            navigationBar.backButton.isHidden = false
        } else {
            navigationBar.backButton.isHidden = true
        }
    }

    @objc open func handlePopAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UIViewControllerTransitioningDelegate

extension ZZViewController: UIViewControllerTransitioningDelegate {

    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimatedTransitioningCls.init(operation: .appear)
    }

    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimatedTransitioningCls.init(operation: .disappear)
    }

    open func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissTransition
    }
}
