//
//  HomeViewController.swift
//  ZZNavigationExample
//
//  Created by Ethan on 2022/10/12.
//  Copyright © 2022 ZZNavigation. All rights reserved.
//

import UIKit
import ZZComponents
import ZZNavigation

struct ZZExample {
   enum Behavior {
       case push
       case present
   }
   var title: String
   var behavior: Behavior
   var cls: UIViewController.Type
}

class HomeViewController: ZZViewController {
   lazy var tableView: UITableView =  {
       $0.delegate = self
       $0.dataSource = self
       $0.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
       $0.backgroundColor = .clear
       $0.tableFooterView = UIView()
       return $0
   }(UITableView(frame: .zero, style: .plain))
   
   var examples: [ZZExample] = [
       .init(title: "Push", behavior: .push, cls: PushViewController.self),
       .init(title: "Present", behavior: .present, cls: PresentViewController.self),
       .init(title: "Curtain", behavior: .present, cls: CurtainViewController.self),
       .init(title: "Panel", behavior: .present, cls: PanelViewController.self)
   ]
   
   override func viewDidLoad() {
       super.viewDidLoad()
       title = "ZZNavigation"
       view.backgroundColor = ZZColor.background
       view.addSubview(tableView)
       tableView.snp.makeConstraints { make in
           make.top.equalTo(navigationBar.snp.bottom)
           make.left.right.bottom.equalToSuperview()
       }
   }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return examples.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
       cell.textLabel?.text = examples[indexPath.row].title
       cell.accessoryType = .disclosureIndicator
       return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
       let item = examples[indexPath.row]
       let cls = item.cls
       if item.behavior == .push {
           navigationController?.pushViewController(cls.init(), animated: true)
       } else {
           present(cls.init(), animated: true, completion: nil)
       }
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
   }
   
   func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       return 49
   }
}
