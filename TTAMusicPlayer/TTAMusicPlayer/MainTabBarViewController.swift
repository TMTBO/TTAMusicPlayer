//
//  MainTabBarViewController.swift
//  MusicPlayer
//
//  Created by ys on 16/11/22.
//  Copyright © 2016年 YS. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configTabBarController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configTabBarController() {
        config(chiledVc: PlayerViewController(), title: "Music", imageName: "music")
        config(chiledVc: MusicListViewController(), title: "MusicList", imageName: "music_list")
    }
    
    private func config(chiledVc : BaseViewController, title : String, imageName : String) {
        chiledVc.title = title;
        let naVc = UINavigationController(rootViewController: chiledVc)
        let item = UITabBarItem(title: title, image: UIImage(named : imageName), selectedImage: UIImage(named: imageName + "_prs"))
        naVc.tabBarItem = item
        self.addChildViewController(naVc)
    }
    

}
