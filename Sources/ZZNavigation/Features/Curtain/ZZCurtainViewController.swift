//
//  ZZCurtainViewController.swift
//  ZZNavigation
//
//  Created by Ethan on 2022/9/30.
//  Copyright © 2022 ZZNavigation. All rights reserved.
//

import UIKit
import ZZComponents

open class ZZCurtainViewController: ZZViewController {

    public lazy var backgroundView: UIView = {
        $0.backgroundColor = ZZColor.systemModal
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        return $0
    }(UIView())

    public lazy var contentView: UIView = {
        $0.backgroundColor = ZZColor.secondarBackground
        $0.layer.cornerRadius = 8
        return $0
    }(UIView())

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

    private func commonInit() {
        modalPresentationStyle = .overFullScreen
        presentAnimatedTransitioningCls = ZZCurtainAnimatedTransitioning.self
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        navigationBar.isHidden = true
        view.addSubview(backgroundView)
        view.addSubview(contentView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: contentSize.height),
            contentView.widthAnchor.constraint(equalToConstant: contentSize.width)
        ])
    }

    @objc open func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
