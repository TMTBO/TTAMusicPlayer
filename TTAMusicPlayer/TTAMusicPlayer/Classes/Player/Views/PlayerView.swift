//
//  PlayerView.swift
//  MusicPlayer
//
//  Created by ys on 16/11/23.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

import UIKit

protocol PlayerViewDelegate: NSObjectProtocol {
    func playerView(_ playerView : PlayerView, didClickPlay : UIButton)
    func playerView(_ playerView : PlayerView, didClickPause: UIButton)
}

class PlayerView: UIView {
    
    var playAndPauseButton : UIButton? = UIButton()
    
//    weak var delegate : PlayerViewDelegate?
    weak var delegate : PlayerViewDelegate?
    
//    var playMusicClosure : (() -> ())? = nil
//    var pauseMusicClosure: (() -> ())? = nil
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}

extension PlayerView {
    func setupUI() {
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        // config
        configPlayButton()
        playAndPauseButton?.tta_addTarget(for: .touchUpInside, actionClosure: { (sender) in
            if PlayerManager.sharedPlayerManager.isPlaying {
                self.delegate?.playerView(self, didClickPause: self.playAndPauseButton!)
                self.configPauseButton()
            } else {
                self.delegate?.playerView(self, didClickPlay: self.playAndPauseButton!)
                self.configPlayButton()
            }
        })
        
        blurView.frame = self.bounds
        
        // add
        self.addSubview(blurView)
        self.addSubview(playAndPauseButton!)
        
        // layout
        playAndPauseButton?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.snp.bottom).offset(-60 * kSCALEP)
        })
    }
    
    func configPlayButton() {
        playAndPauseButton?.setImage(#imageLiteral(resourceName: "cm2_fm_btn_pause"), for: .normal)
        playAndPauseButton?.setImage(#imageLiteral(resourceName: "cm2_fm_btn_pause_prs"), for: .highlighted)
        print("configPlayButton")
    }
    
    func configPauseButton() {
        playAndPauseButton?.setImage(#imageLiteral(resourceName: "cm2_fm_btn_play"), for: .normal)
        playAndPauseButton?.setImage(#imageLiteral(resourceName: "cm2_fm_btn_play_prs"), for: .highlighted)
        print("configPauseButton")
    }
}
