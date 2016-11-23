//
//  PlayerViewController.swift
//  MusicPlayer
//
//  Created by ys on 16/11/22.
//  Copyright © 2016年 YS. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerViewController: BaseViewController {
    var music : MPMediaItem? {
        didSet {
            let bgImage = music?.artwork?.image(at: view.bounds.size)
            view.layer.contents = bgImage == nil ? #imageLiteral(resourceName: "cm2_default_play_bg").cgImage : bgImage?.cgImage
            playMusic()
        }
    }
    
    var playerView : PlayerView?
    var bgImageView : UIImageView?
    var titleLabel : UILabel?
    var navBgImage : UIImage?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBgImage = navigationController?.navigationBar.backgroundImage(for: .default)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(navBgImage, for: .default)
//        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func setupUI() {
        playerView = PlayerView(frame: view.bounds)
        
        playerView?.playMusicClosure = {
            self.playMusic()
        }
        playerView?.pauseMusicClosure = {
            self.pauseMusic()
        }
        
        configNavcBar()
        self.view.addSubview(playerView!)
    }
    
    func configNavcBar() {
        // titleView
        titleLabel = UILabel()
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
        navigationItem.titleView = titleLabel
        
        configNavcTitle()
    }
    
    func configNavcTitle() {
        guard let currentMusic = music else {
            titleLabel?.text = "Music"
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            titleLabel?.sizeToFit()
            return
        }
        let nameAttributeString = NSMutableAttributedString(string: currentMusic.title! + "\n", attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15), NSForegroundColorAttributeName : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        let singerAttributeString = NSMutableAttributedString(string: currentMusic.artist!, attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 12), NSForegroundColorAttributeName : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)])
        
        nameAttributeString.append(singerAttributeString)
        
        titleLabel?.attributedText = nameAttributeString
        titleLabel?.sizeToFit()
    }

}

extension PlayerViewController {
    
    /// 播放
    func playMusic() {
        PlayerManager.sharedPlayerManager.play(music: music)
    }
    
    /// 暂停
    func pauseMusic() {
        PlayerManager.sharedPlayerManager.pause()
    }
}
