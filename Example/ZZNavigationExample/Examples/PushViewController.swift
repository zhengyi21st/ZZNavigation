//
//  PushViewController.swift
//  ZZNavigationExample
//
//  Created by Ethan on 2022/10/12.
//  Copyright © 2022 ZZNavigation. All rights reserved.
//

import UIKit
import ZZComponents
import ZZNavigation

class PushViewController: ZZViewController {

    lazy var pushButton: UIButton = {
        $0.setTitle("Push", for: .normal)
        $0.addTarget(self, action: #selector(handlePush), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))

    lazy var textField: UITextField =  {
        $0.placeholder = "Type someting..."
        $0.leftView = UIView(frame: .init(x: 0, y: 0, width: 16, height: 0))
        $0.rightView = UIView(frame: .init(x: 0, y: 0, width: 16, height: 0))
        $0.leftViewMode = .always
        $0.font = .systemFont(ofSize: 15)
        $0.backgroundColor = ZZColor.secondarBackground
        return $0
    }(UITextField())

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PushViewController"
        view.addSubview(pushButton)
        view.addSubview(textField)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleHideKeyboard)))
        pushButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.height.equalTo(49)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc func handleHideKeyboard() {
        view.endEditing(true)
    }

    @objc func handlePush() {
        navigationController?.pushViewController(PushViewController(), animated: true)
    }

    @objc func handleKeyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
           let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                self.textField.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-(keyboardSize.height - self.view.safeAreaInsets.bottom))
                }
                self.view.layoutSubviews()
            }, completion: nil)
        }
    }

    @objc func handleKeyboardWillHide(notification: NSNotification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
           let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                self.textField.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
                }
                self.view.layoutSubviews()
            }, completion: nil)
        }
    }
}
