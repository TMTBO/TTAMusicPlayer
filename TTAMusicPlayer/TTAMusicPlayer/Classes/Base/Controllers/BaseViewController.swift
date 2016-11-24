//
//  BaseViewController.swift
//  TTAMusicPlayer
//
//  Created by ys on 16/11/22.
//  Copyright © 2016年 YS. All rights reserved.
//

import UIKit

// MARK: - Life Cycle
class BaseViewController: UIViewController {
    lazy var backButton : UIButton? = {
        let backButton = UIButton()
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.setImage(#imageLiteral(resourceName: "cm2_topbar_icn_back"), for: .normal)
        backButton.setImage(#imageLiteral(resourceName: "cm2_topbar_icn_back_prs"), for: .highlighted)
        return backButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configNavBar()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

// MARK: - UI
extension BaseViewController {
    func setupUI() {
        
    }
    
    func configNavBar() {
        navigationItem.leftBarButtonItem?.customView = backButton
    }
}

// MARK: - Actions
extension BaseViewController {
    func backButtonAction() {
       let _ = self.navigationController?.popViewController(animated: true)
    }
}

extension BaseViewController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer, let navc = navigationController {
            return navc.viewControllers.count > 1
        }
        return true
    }
}
