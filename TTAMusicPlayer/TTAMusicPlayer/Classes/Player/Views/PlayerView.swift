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
    @objc optional func playerView(_ playerView : PlayerView, pressProgressSliedr : UISlider)
    @objc optional func playerView(_ playerView : PlayerView, progressSliderValueChanged : UISlider)
    @objc optional func playerView(_ playerView : PlayerView, upInsideProgressSlider : UISlider)
}

class PlayerView: UIView {
    
    weak var delegate : PlayerViewDelegate?
    
    var playAndPauseButton : UIButton? = UIButton()
    var nextButton : UIButton? = UIButton()
    var previewButton : UIButton? = UIButton()
    var progressSlider : UISlider? = UISlider()
    var currentTimeLabel : UILabel? = UILabel()
    var durationTimeLabel : UILabel? = UILabel()
    /// 更新播放器显示的最大时间
    lazy var updateDurationTime : () -> Void = { _ in
        self.progressSlider?.maximumValue = PlayerManager.shared.durationTime
        self.durationTimeLabel?.text = PlayerManager.shared.durationTimeString
    }

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
        
        currentTimeLabel?.font = UIFont.systemFont(ofSize: 15 * kSCALEP)
        currentTimeLabel?.textAlignment = .center
        currentTimeLabel?.text = "00:00"
        
        durationTimeLabel?.font = UIFont.systemFont(ofSize: 15 * kSCALEP)
        durationTimeLabel?.textAlignment = .center
        durationTimeLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        durationTimeLabel?.text = "00:00"
        
        progressSlider?.setMinimumTrackImage(#imageLiteral(resourceName: "cm2_fm_playbar_curr").resizableImage(withCapInsets: .init(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5)), for: .normal)
        progressSlider?.setMaximumTrackImage(#imageLiteral(resourceName: "cm2_fm_playbar_ready").resizableImage(withCapInsets: .init(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5)), for: .normal)
        progressSlider?.setThumbImage(#imageLiteral(resourceName: "cm2_fm_playbar_btn").tta_combineAtCenter(with: #imageLiteral(resourceName: "cm2_fm_playbar_btn_dot")), for: .normal)
        progressSlider?.addTarget(self, action: #selector(pressAction(slider:)), for: .touchDown)
        progressSlider?.addTarget(self, action: #selector(valueChangedAction(slider:)), for: .valueChanged)
        progressSlider?.addTarget(self, action: #selector(upInsideAction(slider:)), for: .touchUpInside)
        
        // add
        self.addSubview(blurView)
        self.addSubview(playAndPauseButton!)
        self.addSubview(nextButton!)
        self.addSubview(previewButton!)
        self.addSubview(currentTimeLabel!)
        self.addSubview(durationTimeLabel!)
        self.addSubview(progressSlider!)
        
        // layout
        playAndPauseButton?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.snp.bottom).offset(-60 * kSCALEP)
        })
        nextButton?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(playAndPauseButton!)
            make.left.equalTo(playAndPauseButton!.snp.right).offset(20 * kSCALEP)
        })
        previewButton?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(playAndPauseButton!)
            make.right.equalTo(playAndPauseButton!.snp.left).offset(-20 * kSCALEP)
        })
        currentTimeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self).offset(12 * kSCALEP)
            make.centerY.equalTo(playAndPauseButton!.snp.centerY).offset(-60 * kSCALEP)
            make.width.equalTo(50 * kSCALEP)
        })
        progressSlider?.snp.makeConstraints({ (make) in
            make.centerX.equalTo(playAndPauseButton!)
            make.left.equalTo(currentTimeLabel!.snp.right).offset(20 * kSCALEP)
            make.centerY.equalTo(currentTimeLabel!)
        })
        durationTimeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(progressSlider!.snp.right).offset(20 * kSCALEP)
            make.centerY.equalTo(progressSlider!)
            make.right.equalTo(self).offset(-12 * kSCALEP)
            make.width.equalTo(50 * kSCALEP)
        })
    }
    /// 配置播放按钮图片
    func configPlayButton() {
        playAndPauseButton?.setImage(#imageLiteral(resourceName: "cm2_fm_btn_pause"), for: .normal)
        playAndPauseButton?.setImage(#imageLiteral(resourceName: "cm2_fm_btn_pause_prs"), for: .highlighted)
        print("configPlayButton")
    }
    /// 配置暂停按钮图片
    func configPauseButton() {
        playAndPauseButton?.setImage(#imageLiteral(resourceName: "cm2_fm_btn_play"), for: .normal)
        playAndPauseButton?.setImage(#imageLiteral(resourceName: "cm2_fm_btn_play_prs"), for: .highlighted)
        print("configPauseButton")
    }
    /// 更新进度条与时间
    open func updateProgressAndTime() {
        progressSlider?.setValue(PlayerManager.shared.currentTime, animated: true)
        currentTimeLabel?.text = PlayerManager.shared.currentTimeString
    }
}

// MARK: - Actions
extension PlayerView {
    /// 播放与暂停
    func didClickPlayAndPauseButton(sender : UIButton) {
        if PlayerManager.shared.isPlaying {
            guard let _ = delegate?.responds(to: #selector(delegate?.playerView(_:pause:))) else { return }
            self.delegate?.playerView?(self, pause: self.playAndPauseButton!)
            self.configPauseButton()
        } else {
            guard let _ = delegate?.responds(to: #selector(delegate?.playerView(_:play:))) else { return }
            self.delegate?.playerView?(self, play: self.playAndPauseButton!)
            self.configPlayButton()
        }
    }
    /// 下一曲
    func didClickNextButton(sender : UIButton) {
        if let _ = delegate?.responds(to: #selector(delegate?.playerView(_:next:))) {
            delegate?.playerView?(self, next: sender)
            self.configPlayButton()
        }
    }
    /// 上一曲
    func didClickPreviewButton(sender : UIButton) {
        if let _ = delegate?.responds(to: #selector(delegate?.playerView(_:preview:))) {
            delegate?.playerView?(self, preview: sender)
            self.configPlayButton()
        }
    }
/** ------------------- progressSlider -------------------------- */
    /// 点击事件    停止定时器
    func pressAction(slider : UISlider) {
        if let _ = delegate?.responds(to: #selector(delegate?.playerView(_:pressProgressSliedr:))) {
            delegate?.playerView?(self, pressProgressSliedr: progressSlider!)
        }
    }
    /// 拖动事件    更新播放时间与进度条
    func valueChangedAction(slider : UISlider) {
        guard let value = progressSlider?.value else {
            return
        }
        currentTimeLabel?.text = PlayerManager.shared.getTimeString(with: TimeInterval(value))
    }
    /// 松开手指事件  设置播放时间,开启定时器
    func upInsideAction(slider : UISlider) {
        PlayerManager.shared.currentTime = slider.value
        if let _ = delegate?.responds(to: #selector(delegate?.playerView(_:upInsideProgressSlider:))) {
            delegate?.playerView?(self, upInsideProgressSlider: progressSlider!)
        }
    }
}
