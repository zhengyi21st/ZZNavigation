//
//  ZZPanelViewController.swift
//  ZZNavigation
//
//  Created by Ethan on 2022/9/30.
//  Copyright © 2022 ZZNavigation. All rights reserved.
//

import UIKit
import ZZComponents

open class ZZPanelViewController: ZZViewController {

    public lazy var backgroundView: UIView = {
        $0.backgroundColor = ZZColor.systemModal
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        return $0
    }(UIView())

    public lazy var contentView: UIView = {
        $0.backgroundColor = ZZColor.secondaryGroupedBackground
        return $0
    }(UIView())

    public lazy var interactiveTransition = ZZPanelInteractiveTransition()
    
    private var contentWidthLayoutConstraint: NSLayoutConstraint?
    
    private var contentHeightLayoutConstraint: NSLayoutConstraint?

    open var contentSize: CGSize {
        return .zero
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.async {
            self.contentWidthLayoutConstraint?.constant = self.contentSize.width
            self.contentHeightLayoutConstraint?.constant = self.contentSize.height
        }
    }

    private func commonInit() {
        modalPresentationStyle = .overFullScreen
        presentAnimatedTransitioningCls = ZZPanelAnimatedTransitioning.self
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentHeightLayoutConstraint?.constant = contentSize.height
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        navigationBar.isHidden = true
        view.addSubview(backgroundView)
        view.addSubview(contentView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentHeightLayoutConstraint = contentView.heightAnchor.constraint(equalToConstant: contentSize.height)
        contentWidthLayoutConstraint = contentView.widthAnchor.constraint(equalToConstant: contentSize.width)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentHeightLayoutConstraint!,
            contentWidthLayoutConstraint!
        ])
        interactiveTransition.track(viewController: self, contentView: contentView)
    }

    @objc open func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
