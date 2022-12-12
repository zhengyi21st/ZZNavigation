//
//  PanelViewController.swift
//  ZZNavigationExample
//
//  Created by Ethan on 2022/10/12.
//  Copyright © 2022 ZZNavigation. All rights reserved.
//

import UIKit
import ZZComponents
import ZZNavigation

class PanelViewController: ZZPanelViewController {
    
    override var contentSize: CGSize {
        return CGSize(width: view.bounds.width, height: 250 + view.safeAreaInsets.bottom)
    }
    
    lazy var scrollView: UIScrollView = {
        $0.alwaysBounceVertical = true
        $0.contentSize.height = 1000
        $0.delegate = self
        if #available(iOS 13.0, *) {
            $0.automaticallyAdjustsScrollIndicatorInsets = false
        }
        return $0
    }(UIScrollView())
    
    lazy var dismissButton: UIButton = {
        $0.setTitle("Dismiss", for: .normal)
        $0.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.contentView.setNeedsUpdateConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.backgroundColor = ZZColor.secondarBackground
        interactiveTransition.scrollView = scrollView
        contentView.addSubview(scrollView)
        scrollView.addSubview(dismissButton)
        scrollView.backgroundColor = ZZColor.background
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.left.right.bottom.equalToSuperview()
        }
        dismissButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(16)
        }
    }
}

extension PanelViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = !interactiveTransition.isProgress
    }
}
