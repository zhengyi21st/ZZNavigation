//
//  ZZNavigationBar.swift
//  ZZComponents
//
//  Created by Ethan on 2022/9/22.
//  Copyright © 2022 ZZComponents. All rights reserved.
//

import UIKit
import ZZComponents

open class ZZNavigationBar: UIView {

    public static func image(name: String, pathExtension: String) -> UIImage? {
        if let imagePath = Bundle(for: ZZNavigationBar.self).url(forResource: "ZZNavigationBar", withExtension: "bundle")?.appendingPathComponent(name).appendingPathExtension(pathExtension).path {
            return UIImage(contentsOfFile: imagePath)
        }
        return nil
    }

    public lazy var backButton: UIButton = {
        $0.setImage(ZZNavigationBar.image(name: "left-11x19", pathExtension: "png"), for: .normal)
        $0.contentEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        $0.tintColor = ZZColor.label
        return $0
    }(UIButton(type: .system))

    public lazy var titleLabel: UILabel = {
        $0.font = ZZFont.headline(weight: .semibold)
        $0.textColor = ZZColor.label
        $0.textAlignment = .center
        return $0
    }(UILabel())

    public lazy var separator: ZZSeparator = ZZSeparator()

    public lazy var contentView = UIView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = ZZColor.background
        addSubview(separator)
        addSubview(contentView)
        contentView.addSubview(backButton)
        contentView.addSubview(titleLabel)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            // add contentView constraint
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            // add separator constraint
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.leftAnchor.constraint(equalTo: leftAnchor),
            separator.rightAnchor.constraint(equalTo: rightAnchor),
            // add backButton constraint
            backButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            backButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        bringSubviewToFront(separator)
        contentView.frame = CGRect(x: safeAreaInsets.left, y: safeAreaInsets.top, width: bounds.width - safeAreaInsets.left - safeAreaInsets.right, height: bounds.height - safeAreaInsets.top)
        layoutTitleLabel()
    }

    public func layoutTitleLabel() {
        var leftMaxX: CGFloat = 16
        var rightMinX: CGFloat = contentView.bounds.width - 16
        contentView.subviews.forEach {
            if $0 != titleLabel, $0.isHidden == false, $0.frame.maxX < bounds.width / 2 {
                leftMaxX = max(leftMaxX, $0.frame.maxX)
            }
            if $0 != titleLabel, $0.isHidden == false, $0.frame.minX > bounds.width / 2 {
                rightMinX = min(rightMinX, $0.frame.minX)
            }
        }
        titleLabel.frame = CGRect(x: leftMaxX, y: 0, width: rightMinX - leftMaxX, height: contentView.bounds.height)
    }

}
