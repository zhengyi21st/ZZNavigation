//
//  PresentViewController.swift
//  ZZNavigationExample
//
//  Created by Ethan on 2022/10/12.
//  Copyright © 2022 ZZNavigation. All rights reserved.
//

import UIKit
import ZZNavigation

class PresentViewController: ZZViewController {
    
    lazy var dismissButton: UIButton = {
        $0.setTitle("Dismiss", for: .normal)
        $0.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
        view.addSubview(dismissButton)
        dismissButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
