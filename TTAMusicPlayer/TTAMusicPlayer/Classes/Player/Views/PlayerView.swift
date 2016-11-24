//
//  PlayerView.swift
//  MusicPlayer
//
//  Created by ys on 16/11/23.
//  Copyright © 2016年 TobyoTenma. All rights reserved.
//

import UIKit

@objc protocol PlayerViewDelegate: NSObjectProtocol {
    @objc optional func playerView(_ playerView : PlayerView, play : UIButton)
    @objc optional func playerView(_ playerView : PlayerView, pause: UIButton)
    @objc optional func playerView(_ playerView : PlayerView, next : UIButton)
    @objc optional func playerView(_ playerView : PlayerView, preview : UIButton)
}

class PlayerView: UIView {
    
    weak var delegate : PlayerViewDelegate?
    
    var playAndPauseButton : UIButton? = UIButton()
    var nextButton : UIButton? = UIButton()
    var previewButton : UIButton? = UIButton()
    
    

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
        blurView.frame = self.bounds
        
        configPlayButton()
        playAndPauseButton?.addTarget(self, action: #selector(didClickPlayAndPauseButton(sender:)), for: .touchUpInside)
        
        nextButton?.addTarget(self, action: #selector(didClickNextButton(sender:)), for: .touchUpInside)
        nextButton?.setImage(#imageLiteral(resourceName: "cm2_fm_btn_next"), for: .normal)
        nextButton?.setImage(#imageLiteral(resourceName: "cm2_fm_btn_next_prs"), for: .highlighted)
        
        previewButton?.addTarget(self, action: #selector(didClickPreviewButton(sender:)), for: .touchUpInside)
        previewButton?.setImage(#imageLiteral(resourceName: "cm2_play_btn_prev"), for: .normal)
        previewButton?.setImage(#imageLiteral(resourceName: "cm2_play_btn_prev_prs"), for: .highlighted)
        
        
        // add
        self.addSubview(blurView)
        self.addSubview(playAndPauseButton!)
        self.addSubview(nextButton!)
        self.addSubview(previewButton!)
        
        // layout
        playAndPauseButton?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.snp.bottom).offset(-60 * kSCALEP)
        })
        nextButton?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(playAndPauseButton!)
            make.left.equalTo(playAndPauseButton!.snp.right).offset(25 * kSCALEP)
        })
        previewButton?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(playAndPauseButton!)
            make.right.equalTo(playAndPauseButton!.snp.left).offset(-25 * kSCALEP)
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

// MARK: - Actions
extension PlayerView {
    /// 播放与暂停
    func didClickPlayAndPauseButton(sender : UIButton) {
        if PlayerManager.sharedPlayerManager.isPlaying {
            self.delegate?.playerView?(self, pause: self.playAndPauseButton!)
            self.configPauseButton()
        } else {
            self.delegate?.playerView?(self, play: self.playAndPauseButton!)
            self.configPlayButton()
        }
    }
    
    /// 下一曲
    func didClickNextButton(sender : UIButton) {
        delegate?.playerView?(self, next: sender)
        self.configPlayButton()
    }
    
    /// 上一曲
    func didClickPreviewButton(sender : UIButton) {
        delegate?.playerView?(self, preview: sender)
        self.configPlayButton()
    }
}
