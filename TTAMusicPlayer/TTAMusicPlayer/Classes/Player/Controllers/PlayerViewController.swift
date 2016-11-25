//
//  PlayerViewController.swift
//  MusicPlayer
//
//  Created by ys on 16/11/22.
//  Copyright © 2016年 YS. All rights reserved.
//

import UIKit
import MediaPlayer

// MARK: - LifeCycle
class PlayerViewController: BaseViewController{
    var music : MPMediaItem? {
        didSet {
            configMusicInfo()
        }
    }
    
    var playerView : PlayerView?
    var bgImageView : UIImageView?
    var titleLabel : UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        
        playMusic()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let playingMusic = PlayerManager.shared.musics[PlayerManager.shared.playingIndex]
        music = music == playingMusic ? music : playingMusic
        PlayerManager.shared.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit {
        print("PlayerViewController deinit")
    }
}

// MARK: - UI
extension PlayerViewController {
    override func setupUI() {
        playerView = PlayerView(frame: view.bounds)
        playerView?.delegate = self
        
        self.view.addSubview(playerView!)
        configNavcBar()
    }
    
    func configNavcBar() {
        // bgView
        let blur = UIBlurEffect(style: .dark)
        let bgView = UIVisualEffectView(effect: blur)
        bgView.alpha = 0.3
        
        // lineView
        let lineView = UIView(frame: CGRect(x: 0, y: 64, width: kSCREEN_WIDTH, height: 1.0 / kSCREEN_SCALE))
        lineView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        // titleView
        titleLabel = UILabel()
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
        configNavcTitle()
        
        // add
        view.addSubview(bgView)
        view.addSubview(backButton!)
        view.addSubview(titleLabel!)
        view.addSubview(lineView)
        
        
        // layout
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(64)
        }
        titleLabel?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(view)
            make.top.equalTo(28)
        })
        backButton?.snp.makeConstraints({ (make) in
            make.left.equalTo(view).offset(12 * kSCALEP)
            make.top.equalTo(view).offset(26)
        })
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
    
    func configMusicInfo() {
        // background
        let bgImage = music?.artwork?.image(at: view.bounds.size)
        view.layer.contents = bgImage == nil ? #imageLiteral(resourceName: "cm2_default_play_bg").cgImage : bgImage?.cgImage
        playerView?.configIconImageView(with: bgImage ?? #imageLiteral(resourceName: "cm2_default_play_bg"))
        // title
        configNavcTitle()
    }
}

// MARK: - Player Control
extension PlayerViewController {
    /// 播放
    func playMusic() {
        if let newMusic = music {
            PlayerManager.shared.play(music : newMusic)
        } else {
            PlayerManager.shared.play(music : PlayerManager.shared.musics[0])
        }
        playerView?.updateDurationTime()
    }
    /// 暂停
    func pauseMusic() {
        PlayerManager.shared.pause()
    }
    /// 下一曲
    func nextMusic() {
        PlayerManager.shared.next()
    }
    /// 上一曲
    func previousMusic() {
        PlayerManager.shared.previous()
    }
}


// MARK: - PlayerViewDelegate
extension PlayerViewController : PlayerViewDelegate {
    func playerView(_ playerView: PlayerView, play: UIButton) {
        playMusic()
    }
    func playerView(_ playerView: PlayerView, pause: UIButton) {
        pauseMusic()
    }
    func playerView(_ playerView: PlayerView, next: UIButton) {
        nextMusic()
    }
    func playerView(_ playerView: PlayerView, preview: UIButton) {
        previousMusic()
    }
}

// MARK: - PlayerManagerDelegate
extension PlayerViewController : PlayerManagerDelegate {
    func playerManager(_ playerManager: PlayerManager, playingMusic: MPMediaItem) {
        self.music = playingMusic
    }
    func playerManagerUpdateProgressAndTime(_ playerManager: PlayerManager) {
        playerView?.updateProgressAndTime()
    }
}
